module Web::RequestEngine::Parts
  def part_class_names(type)
    part_class_set_by_type[type].map(&:name)
  end

  def part_class_set_by_type
    @part_class_set_by_type ||= Hash.new { |hash, type|
      hash[type] = Set.new
    }
  end

  def uses(pluralized_type)
    singular_type = pluralized_type.to_s.singularize.to_sym
    type_directory = singular_type.to_s

    rails_application = Rails.application
    rails_engines = [rails_application, *::Rails::Engine.subclasses.map(&:instance)]

    rails_engines.each do |rails_engine|
      models_directories = rails_engine.paths['app/models'].existent_directories

      models_directories.each do |models_directory|
        models_pathname = Pathname.new(models_directory)
        type_pathname = models_pathname.join('web', 'request_engine', type_directory)

        if type_pathname.directory?
          Metasploit::Pro::Loading.each_pathname_constant(type_pathname, :relative_to => models_pathname) do |klass|
            part_class_set_by_type[singular_type].add klass
          end
        end
      end
    end
  end
end