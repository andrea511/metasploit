class MetamoduleEngineGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def metamodule_root
    @metamodule_root ||= Rails.root.parent.join("metamodules/#{file_name}")
  end

  def generate_engine
    inside('../metamodules') do
      run("rails plugin new #{file_name} --mountable --skip-test-unit")
    end
  end

  def generate_javascripts
    path = "app/assets/javascripts/"
    template "#{path}/generic/metamodule_modal.coffee.erb", "#{@metamodule_root}/#{path}#{file_name}/#{file_name}.coffee.erb"
  end

  def generate_controllers
    path = "app/controllers/"
    template "#{path}/generic/task_config_controller.rb", "#{@metamodule_root}/#{path}#{file_name}/task_config_controller.rb"
  end

  def generate_models
    path = "app/models/"
    template "#{path}/generic/task_config.rb", "#{@metamodule_root}/#{path}#{file_name}/task_config.rb"
  end

  def generate_views
    path = "app/views/"
    template "#{path}/generic/task_config/_form.html.erb", "#{@metamodule_root}/#{path}#{file_name}/task_config/_form.html.erb"
  end


  def generate_rpc_monkeypatches
    path = "lib/"
    template "#{path}generic/rpc/client.rb", "#{@metamodule_root}/#{path}#{file_name}/rpc/client.rb"
    template "#{path}generic/rpc/tasks.rb", "#{@metamodule_root}/#{path}#{file_name}/rpc/tasks.rb"
  end

  def generate_routes
    path =  "#{@metamodule_root}/config/routes.rb"
    inject_into_file path, after: "#{file_name.camelize}::Engine.routes.draw do" do <<-EOS

    resources :task_config
    EOS
    end
  end

  def generate_rpc_require
    path =  "#{@metamodule_root}/lib/#{file_name}.rb"
    inject_into_file path, after: "require \"#{file_name}/engine\"" do  <<-EOS

require "#{file_name}/rpc/client"
require "#{file_name}/presenters/#{file_name}"
    EOS
    end
  end

  def generate_presenter
    path = "lib/"
    template "#{path}/generic/presenters/generic.rb", "#{@metamodule_root}/#{path}#{file_name}/presenters/#{file_name}.rb"
  end

  def generate_commander
    path = "lib/"
    template "#{path}/generic/modules/auxiliary/metamodule/generic.rb", "#{@metamodule_root}/#{path}#{file_name}/modules/auxiliary/metamodule/#{file_name}.rb"
  end

  def generate_yaml
    path = 'config/'
    template "#{path}/metamodule.yml",  "#{@metamodule_root}/#{path}metamodule.yml"
    #template "#{path}/initializers/register_metamodule.rb", "#{@metamodule_root}/#{path}initializers/register_metamodule.rb"
  end

  # this may now be a misnomer as it configured eager_load_paths due to Rails 5 production changes
  def add_autoload_path
    path =  "#{@metamodule_root}/lib/#{file_name}/engine.rb"
    inject_into_file path, after: "isolate_namespace #{file_name.camelize}" do <<-EOS

    config.eager_load_paths += [config.root.join('lib').to_s]
    config.autoload_paths += [config.root.join('lib').to_s]
    EOS
    end
  end

  def cleanup
    run("rm #{@metamodule_root}/.gitignore")
    run("rm #{@metamodule_root}/demo_engine.gemspec")
    run("rm #{@metamodule_root}/Gemfile")
    run("rm #{@metamodule_root}/MIT-LICENSE")
    run("rm #{@metamodule_root}/Rakefile")
    run("rm #{@metamodule_root}/README.rdoc")
    run("rm -fr #{@metamodule_root}/app/views/layouts")
    run("rm #{@metamodule_root}/app/controllers/#{file_name}/application_controller.rb")
    run("rm -fr #{@metamodule_root}/app/helpers")
    run("rm -fr #{@metamodule_root}/lib/tasks")
  end


end
