module Metasploit::Pro::Engine::Rpc::Modules

  @@module_type_cache = {}
  @@module_cache_mod_time = Time.now.getutc

  # holding onto all module names and only updating if the cache reports a change
  # we already do a similar check in framework for the json cache creation
  def rpc_modules(mtype)
    ret = {}

    names = []
    case mtype
    when 'exploit'
      names = self.framework.exploits.keys.map{ |x| "exploit/#{x}" }
    when 'auxiliary'
      names = self.framework.auxiliary.keys.map{ |x| "auxiliary/#{x}" }
    when 'post'
      names = self.framework.post.keys.map{ |x| "post/#{x}" }
    when 'payload'
      names = self.framework.payloads.keys
    when 'encoder'
      names = self.framework.encoders.keys
    end

    names.reject!{|mname| mname.index('auxiliary/pro/') }
    names.reject!{|mname| mname.index('auxiliary/gather/http_pdf_authors')}

    # Exclude unsupported modules by name, since no specific mixin used
    names.reject! { |n| n.include? '/telephony/' or n.include? '/test/' }

    updated = false
    # process times for framework cache modules
    Msf::Modules::Metadata::Cache.instance.get_metadata.each do |mod_obj|
      mod_time = mod_obj.mod_time
      if mod_time > @@module_cache_mod_time
        @@module_cache_mod_time = mod_time
        updated = true
      end
    end

    if !updated && @@module_type_cache[mtype]
      return @@module_type_cache[mtype]
    end

    names.each do |mname|
      begin
        m = framework.modules.create(mname)

        # Skip modules that trigger any sort of error
        next if not m
      rescue StandardError, LoadError
        next
      end

      res = {}

      # Exclude modules that use unsupported mixins
      exclude = false

      [
        ::Msf::Exploit::DECT_COA,
        ::Msf::Exploit::ORACLE
      ].each { |mixin|
        if m.class.ancestors.include? mixin
          exclude = true
          break
        end
      }
      next if exclude

      res = _module_to_hash(m)

      if m.class.ancestors.include? ::Msf::Exploit::FILEFORMAT
        res['fileformat'] = true
      end

      ret[m.fullname] = res
    end

    @@module_type_cache[mtype] = {'modules' => ret}
  end

  def rpc_module_validate(name, opts)
    mod = _find_module(name)
    opts.each_pair {|k,v| mod.datastore[k] = v }

    begin
      mod.options.validate(mod.datastore)
      {'result' => 'success'}
    rescue ::Exception => e
      {'result' => 'failure', 'error' => e.to_s }
    end
  end

  def rpc_module_search(str)
    res = {}
    matches = []
    framework.modules.each do |m|
      o = framework.modules.create(m[0]) rescue nil
      next if not m
      if not o.search_filter(str)
        res[o.fullname] = _module_to_hash(o)
      end
    end

    { 'matches' => res }
  end

private

  def _module_to_hash(m)
    res = {}

    res['type'] = m.type
    res['name'] = m.name.to_s
    res['rank'] = m.rank.to_i
    res['description'] = m.description.to_s
    res['license'] = m.license.to_s
    res['filepath'] = m.file_path.to_s
    res['arch'] = m.arch.map{|x| x.to_s}
    res['platform'] = m.platform.platforms.map{|x| x.to_s}
    res['notes'] = m.notes

    res['references'] = m.references.map do |r|
      [r.ctx_id.to_s, r.ctx_val.to_s]
    end

    res['authors'] = m.author.map{|a| a.to_s}

    res['privileged'] = m.privileged?

    if m.disclosure_date
      begin
        res['disclosure_date'] = m.disclosure_date.to_datetime.to_time.to_i
      rescue ::Exception
        res.delete('disclosure_date')
      end
    end

    if(m.type == "exploit")
      res['targets'] = {}

      m.targets.each_index do |i|
        res['targets'][i] = m.targets[i].name.to_s
      end

      if (m.default_target)
        res['default_target'] = m.default_target.to_s
      end

      # Some modules are a combination, which means they are actually aggressive
      res['stance'] = m.stance.to_s.index("aggressive") ? "aggressive" : "passive"
    end

    if m.type == "auxiliary" or m.type == "post"
      res['actions'] = {}

      m.actions.each_index do |i|
        res['actions'][i] = m.actions[i].name.to_s
      end

      if (m.default_action)
        res['default_action'] = m.default_action.to_s
      end

      if m.type == "auxiliary"
        res['stance'] = m.passive? ? "passive" : "aggressive"
      end
    end

    if m.type == "payload" or m.type == "encoder"
      opts = {}
      m.options.each_key do |k|
        o = m.options[k]
        opts[k] = {
          'type'     => o.type,
          'required' => o.required,
          'advanced' => o.advanced,
          'evasion'  => o.evasion,
          'desc'     => o.desc
        }

        if(not o.default.nil?)
          opts[k]['default'] = o.default
        end

        if(o.enums.length > 1)
          opts[k]['enums'] = o.enums
        end
      end
      res['fullname'] = m.fullname
      res['options'] = opts
    end

    res
  end

end
