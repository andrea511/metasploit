module AnalysisSearchMethods
  require 'shellwords'
  require 'treetop'
  require 'grammars/boolean_expression'

  # when any of these chars are included in the search query, the query is parsed by a
  # CFG and rolled into a long INTERSECT/UNION query
  BOOLEAN_CHARS = ['(', ')', '&&', '||']

  def pro_search(controller, grouped=false, search_input=params[:sSearch], workspace=@workspace )
    node = if search_input.present? and BOOLEAN_CHARS.any? { |x| search_input.include?(x) }
      BooleanExpressionParser.new.parse(search_input)
    end
    if node
      resource = "Mdm::#{controller.to_s.capitalize.singularize}".constantize
      base = base_dataset(controller, grouped, workspace)
      query = node.search_recursive([], controller, grouped, self, workspace)
      prepared_statement = "\"workspace_id\" = $1"
      bind_params = query.include?(prepared_statement) ? { workspace_id: workspace.id } : {}
      resource_id = resource.find_by_sql(query, bind_params)
      base.where(id: resource_id)
    else
      pro_search_iter(controller, grouped, search_input, workspace)
    end
  end

  # called on every leaf node of the (possibly) nested query
  #
  # TODO: we should rewrite this to use the has_scopes filtering the rest API uses
  def pro_search_iter(controller, grouped=false, search_input=params[:sSearch], workspace=@workspace)
    dataset = base_dataset(controller,grouped,workspace)
    return dataset if search_input.blank?
    if is_quoted_string?(search_input)
      search_input = strip_quotes(search_input)
      return dataset if search_input.blank?
      return dataset.search(search_input)
    end
    return dataset.search(search_input) unless search_input =~ /[#:<=>]+/


    where_clause = ""
    where_params = []
    having_clause = ""
    having_params = []
    tag_clauses = []
    tag_params = []

    search_terms = self.search_terms(controller, grouped)

    search_params = Shellwords.split(search_input) rescue [ search_input ]
    search_params.each do |parameter|
      next if parameter.blank?

      unless keyed_term?(search_terms, parameter) or parameter.start_with? "#"
        dataset = dataset.search(parameter)
        next
      end

      if parameter.start_with? "#"
        results = tag_query(parameter)
        tag_clauses << results[0]
        tag_params << results[1]
      else
        sep = term_seperator(parameter)
        term = parameter.split(sep,2)
        next unless term[0] and term[1]
        term[0].downcase!

        #Skip this search term if it's not a valid term for this controller
        next if search_terms[term[0]].nil?

        if search_terms[term[0]][0] == :text
          results = text_query(term[0],term[1],sep,controller,where_params.length)
          where_clause << results[0]
          where_params << results[1]
        elsif search_terms[term[0]][0] == :address
          results = address_query(term[1],sep,where_params.length)
          where_clause << results[0]
          where_params << results[1]
        #Accounts for the base64 serialization fields we may run into
        elsif search_terms[term[0]][0] == :serial
          results = serial_query(term[0],term[1],sep,controller,where_params.length)
          where_clause << results[0]
          where_params << results[1]
        else
          sep = "=" if sep == ":"
          if search_terms[term[0]][1] == :where
            results = numeric_where_query(term[0],term[1],sep,controller,where_params.length)
            where_clause << results[0]
            where_params << results[1]
          else
            results = numeric_having_query(term[0],term[1],sep,controller,having_params.length)
            having_clause << results[0]
            having_params << results[1]
          end
        end
      end
    end

    if having_params.length > 0
      having_params.flatten!
      dataset = dataset.having(having_clause, *having_params)
    end
    if where_params.length > 0
      where_params.flatten!
      dataset = dataset.where(where_clause, *where_params)
    end
    if tag_params.length > 0
      tag_fclause = "hosts.id IN ( #{tag_clauses.join(" INTERSECT ")} ) "
      dataset = dataset.where(tag_fclause, *tag_params)
    end
    return dataset
  end

  #Does our initial querying to give us a base dataset to work off of
  def base_dataset(controller,grouped=false,workspace=@workspace)
    case controller
    when :services
      dataset = workspace.services.reorder('')

      if not grouped
        dataset = dataset.select("services.*")
      else
        dataset = dataset.select("DISTINCT(services.name, services.proto, services.port, services.info)").
          joins("LEFT OUTER JOIN hosts_tags ON hosts_tags.host_id=services.host_id LEFT OUTER JOIN tags ON hosts_tags.tag_id=tags.id").
          select("COUNT(services.id) as host_count, services.name, services.proto, services.port, services.info").
          group("services.name, services.proto, services.port, services.info")
      end

      @services_total_count = dataset.length
    when :notes
      dataset = workspace.notes

      if not grouped
        dataset = dataset.select("notes.*").
          joins(:host)
      else
        dataset = dataset.select("DISTINCT(notes.ntype)").
          joins("INNER JOIN hosts ON notes.host_id = hosts.id LEFT OUTER JOIN hosts_tags ON hosts_tags.host_id=notes.host_id LEFT OUTER JOIN tags ON hosts_tags.tag_id=tags.id").
          select("COUNT(notes.id) AS host_count, notes.ntype").group("notes.ntype")
      end

      @notes_total_count = dataset.length
    when :loots
      dataset = workspace.loots.reorder('')
      dataset = dataset.select("loots.*").
          joins(:host).
          group("loots.id, hosts.name")
      @loots_total_count = dataset.length
    when :vulns
      dataset = workspace.vulns

      if grouped
        vulns = Mdm::Vuln.arel_table
        id = vulns[:id]
        name = vulns[:name]

        dataset = dataset.select([
          'DISTINCT(vulns.name)',
          id.count.as('host_count'),
          id.maximum.as('id'),
        ]).group(name)
      else
        dataset = dataset.select('vulns.*')
          .includes(:service)
          .joins(ArelHelpers.join_association(Mdm::Vuln, :refs, Arel::Nodes::OuterJoin))
      end

      @vulns_total_count = dataset.length
    when :hosts
      dataset = workspace.hosts
      dataset = dataset.select("hosts.*").
          includes(:tags).
          group('hosts.id')
      @hosts_total_count = dataset.length
    when :related_modules
      vulns = Mdm::Vuln.joins(:host).where(hosts:{workspace_id: workspace.id})
      dataset = Mdm::Module::Detail.distinct.with_table_data.related_modules(vulns)
      @related_modules_total_count = dataset.length
    when :web_vulns
      dataset = workspace.web_vulns
    end

    dataset
  end


  #Hashes with acceptable search params, the general type of data
  def search_terms(controller,grouped=false)
    param_validator = {
      "ip"                 => [:address , :where],
      "hostname"           => [:text , :where],
    }
    param_validator.merge!({"hosts" => [:number, :having]}) if grouped
    case controller
    when :services
      param_validator.merge!({
        "name"           => [:text , :where],
        "proto"          => [:text , :where],
        "port"           => [:number, :where],
        "info"           => [:text , :where],
      })
    when :notes
      param_validator.merge!( {
        "type"           => [:text , :where],
        "data"           => [:serial , :where],
      })
    when :loots
      param_validator.merge!( {
        "type"           => [:text , :where],
        "name"           => [:text , :where],
        "info"           => [:text , :where]
      })
    when :vulns
      param_validator.merge!( {
        "name"           => [:text , :where],
        "info"           => [:text , :where],
        "ref"            => [:text , :where]
        })
    when :hosts
      param_validator.merge!( {
        "name"           => [:text, :where],
        "os"             => [:text, :where],
        "version"        => [:text, :where],
        "purpose"        => [:text, :where],
        "vulns"          => [:number, :where],
        "services"       => [:number, :where]
        })
    end
    return param_validator
  end


  #Converts userfacing terms into the appropriate data to be used in the SQL query
  def sql_term(controller,term)
    case term
    when "hostname"
      return "hosts.name"
    when "ip"
      return "hosts.address::text"
    when "name"
      return "#{controller}.name"
    when "hosts"
      return "COUNT(#{controller}.id)"
    when "vulns"
      return "#{controller}.vuln_count"
    when "services"
      return "#{controller}.service_count"
    when "attempts"
      return "hosts.exploit_attempt_count"
    when "version"
      return "os_sp"
    when "os"
      return "os_name||' '||os_flavor"
    when "info"
      return "#{controller}.info"
    when "type"
      case controller
      when :notes
        return "ntype"
      when :loots
        return "ltype"
      end
    when "ref"
      return "refs.name"
    else
      return term
    end
  end

  def term_seperator(str)
    case str
    when /!:/
      return "!:"
    when /<>/
      return "<>"
    when /<=/
      return "<="
    when />=/
      return ">="
    when /</
      return "<"
    when />/
      return ">"
    when /\=/
      return "="
    else
      return ":"
    end
  end

  def param_joiner(num_params)
    return "AND" if num_params > 0
    return ""
  end

  #Some quick quoted string functions to allow the search box to be quoted to escape any special charachters
  def is_quoted_string?(str)
    str = str.lstrip.rstrip
    ((str.start_with?("'") or str.start_with?('"')) and (str.end_with?("'") or str.end_with?('"')))
  end

  def strip_quotes(str)
    return str unless is_quoted_string?(str)
    str.gsub!(/['"]/,'')
  end

  def text_query(field,value,sep,controller,where_count)
    field = sql_term(controller,field)
    case sep
    when ":"
      sep = "ILIKE"
      value = "%#{value}%"
    when "="
      sep = "="
    when "<>"
      sep = "<>"
    else
      sep = "NOT ILIKE"
      value = "%#{value}%"
    end
    where_clause = "#{param_joiner(where_count)} #{field} #{sep} ? "
    where_params = "#{value}"
    return [where_clause,where_params]
  end

  def address_query(value,sep,where_count)
    case sep
    when ":"
      where_clause = "#{param_joiner(where_count)} hosts.address::text ILIKE ? "
      where_params = "%#{value}%"
    when "!:"
      where_clause = "#{param_joiner(where_count)} hosts.address::text NOT ILIKE ? "
      where_params = "%#{value}%"
    when "="
      where_clause = "#{param_joiner(where_count)} Host(hosts.address)=Host(?) "
      where_params = "#{value}"
    when "<>"
      where_clause = "#{param_joiner(where_count)} Host(hosts.address)<>Host(?) "
      where_params = "#{value}"
    end
    return [where_clause,where_params]
  end

  def serial_query(field,value,sep,controller,where_count)
    field = sql_term(controller,field)
    if sep == ":"
      sep = "LIKE"
      value = "%#{value}%"
    else
      sep = "NOT LIKE"
      value = "%#{value}%"
    end
    where_clause = "#{param_joiner(where_count)} (#{field} NOT ILIKE 'BAh7%' AND #{field} #{sep} ? ) OR (#{field} ILIKE 'BAh7%' AND decode(#{field}, 'base64') #{sep} ? ) "
    where_params = ["#{value}", "#{value}"]
    return [where_clause,where_params]
  end

  def numeric_where_query(field,value,sep,controller,where_count)
    field = sql_term(controller,field)
    where_clause = "#{param_joiner(where_count)} #{field}#{sep}? "
    where_params = value.to_i
    return [where_clause,where_params]
  end

  def numeric_having_query(field,value,sep,controller,having_count)
    field = sql_term(controller,field)
    having_clause = "#{param_joiner(having_count)} #{field}#{sep}? "
    having_params = value.to_i
    return [having_clause,having_params]
  end

  def tag_query(tag)
    clause = "Select hosts_tags.host_id from tags INNER JOIN hosts_tags on tags.id=hosts_tags.tag_id WHERE tags.name ILIKE ? "
    param = tag.downcase.gsub("#", '')
    return [clause,param]
  end

  def keyed_term?(sterms,parameter)
    sterms.keys.each{|valid_term| return true if parameter.match( /^#{valid_term}([!:<=>]+)/)}
    return false
  end
end
