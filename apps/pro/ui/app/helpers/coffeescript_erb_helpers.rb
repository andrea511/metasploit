module CoffeescriptErbHelpers

  def metamodule_dir_map
    file_map = {}

    Metasploit::Pro::Metamodules.roots.each do |root|
      file_map.merge!(
        generate_map(
          engine: true,
          path: root.join("app/assets/javascripts", root.basename)
        )
      )
    end

    full_path = Rails.root.join('app/assets/javascripts').join('apps/backbone/views/modal_views')
    generate_map(file_map: file_map, path: full_path)
    file_map
  end


  #TODO Remove Conditional for Engine vs. Non-Engine MetaModule
  def generate_map(options={})
    options.reverse_merge!({:file_map=>{}, :engine=>false})
    Dir.new(options[:path]).each do |file|
      next if File.basename(file).start_with?('.')
      short_name = File.basename(file, File.extname(file)).sub(/\..*$/, '')
      orig_metamodule_path = 'apps/backbone/views/modal_views'
      options[:file_map][short_name] = if options[:engine]
        javascript_path("#{short_name}/#{short_name}")
      else
        javascript_path(File.join(orig_metamodule_path, short_name))
      end
    end
    options[:file_map]
  end

  def jquery_path
    js_path('shared/backbone/jquery-require-bootstrap')
  end

  def backbone_path
    js_path('shared/backbone/backbone-require-bootstrap')
  end

  def marionette_path
    js_path('shared/backbone/marionette-require-bootstrap')
  end

  def cocktail_path
    js_path('shared/backbone/cocktail-require-bootstrap')
  end

  def jquery_ui_path
    js_path('jquery-ui-1.8.18.custom.min')
  end

  def underscore_path
    js_path('shared/backbone/underscore-require-bootstrap')
  end

  # Generate a JavaScript path suitable for requirejs.
  #
  # @param asset_path [String] the path to the JavaScript asset
  #
  # @return [String] the path to the asset, minus the file extension
  def js_path(asset_path)
    javascript_path(asset_path).gsub(/\.js$/, '')
  end

  def css_path(asset_path)
    stylesheet_path(asset_path).gsub(/\.css$/, '')
  end

  # Given a directory, generate a map of relative js files to their digest URLs:
  #   'relative/file/path' => '/path/to/js.js?digest=1231245' or '/path/to/css.css?digest=1231245'
  #
  # @param dir [String] the directory to map
  # @param opts [Hash] the options hash
  # @option opts :indent [Integer] number of two-space indentations to add to the output string
  # @option opts :stylesheet [Boolean] true if the directory contains stylesheets
  # @return [String] of newline separated "relative.js": "relative.js?digest=123" pairs or css
  def requirejs_dir(dir, opts={})
    base_path  = opts[:base_path]
    dir_path   = base_path.join(dir)
    indent     = opts.fetch(:indent, 0)
    style_path = opts.fetch(:stylesheet, false)

    # file_map is a [Hash<String, String>] map of relative js files -> digest URLs
    file_map = Dir.glob(File.join(dir_path, '**', '*')).each_with_object({}) do |file, map_obj|
      path = dir_path.join(file)
      next if ['.', 'require_config','manifest'].any? { |prefix| File.basename(file).start_with?(prefix) }
      next if ['.orig'].any? { |suffix| File.basename(file).end_with?(suffix) }
      next if path.directory?
      relative_path = relative_asset_path(path,dir_path)

      # Calculate the path differently if this is a stylesheet.
      require_path_base = path.relative_path_from(base_path).to_s.gsub(/\..*$/,'')
      require_path = style_path ? stylesheet_path(require_path_base).gsub('.css','') : require_asset_path(require_path_base)

      map_obj[relative_path] = require_path
    end

    spacing = "  "*indent

    file_map.keys.collect { |k| "#{spacing}'#{k}': '#{file_map[k]}'" }.join("\n")
  end

  # Given a directory, generate a map of relative css files to their digest URLs:
  #   'relative/file/path' => '/path/to/css.css?digest=1231245'
  #
  # @param dir [String] the directory to map
  # @param opts [Hash] the options hash
  # @option opts :indent [Integer] number of two-space indentations to add to the output string
  # @option opts :root_directory [String] directory to use as root of relative
  #   file path (default: 'app/assets/stylesheets')
  # @return [String] of newline separated "css/relative.css": "relative.css?digest=123" pairs or css
  def requirejs_css_dir(dir,opts={})
    root_directory = opts.fetch(:root_directory, 'app/assets/stylesheets')

    base_path = Pathname.new Rails.root.join(root_directory)
    requirejs_dir(dir,opts.merge(base_path:base_path, stylesheet: true))
  end

  # Given a directory, generate a map of relative js files to their digest URLs:
  #   'relative/file/path' => '/path/to/js.js?digest=1231245'
  #
  # @param dir [String] the directory to map
  # @param opts [Hash] the options hash
  # @option opts :indent [Integer] number of two-space indentations to add to the output string
  # @return [String] of newline separated "relative.js": "relative.js?digest=123" pairs or css
  def requirejs_js_dir(dir,opts={})
    base_path = Pathname.new Rails.root.join('app/assets/javascripts')
    requirejs_dir(dir,opts.merge(base_path:base_path))
  end

  # Given a file path, look up the file digest path depending on the asset type.
  #
  # @param path [String] the file path
  # @return [String] the file digest path
  def require_asset_path(path)
    if path.include? "stylesheets"
      css_path(path)
    else
      js_path(path)
    end
  end

  # Give a file path, generate the require config path key
  # @param path [FilePath] the file path for the asset
  # @param dir_path [FilePath] the base path to stylesheet/javascript asset dir
  def relative_asset_path(path,dir_path)
    if path.to_s.include? "stylesheets"
      'css/'+path.relative_path_from(dir_path).to_s.gsub(/\..*$/,'')
    else
      path.relative_path_from(dir_path).to_s.gsub(/\..*$/,'')
    end
  end

  # Embeds the ruby constants from a module into javascript code
  #
  # @param [Module] mod the module to pull constants from
  # @return [String] javascript code containing a Hash maps constant name -> constant value
  #   for every constant in the given ruby module
  def const_map(mod_str)
    mod = mod_str.constantize
    map = mod.constants.each_with_object({}) { |const, obj|
      obj[const] = mod.const_get(const)
    }
    map.to_json
  end

end
