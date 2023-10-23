class LicensesController < ApplicationController

	skip_before_action :require_license

	before_action :load_license
	before_action :load_product_key, :only => [:index, :request_key, :registration, :activation]

	before_action :require_admin, :except => [:require_license]

	def index
		if not (@license.registered? and @license.activated?)
			flash.keep(:error)
			redirect_to activation_path
		end
	end

	def setup
		if not (@license.registered? and @license.activated?)
			flash.keep(:error)
			redirect_to activation_path
		else
			redirect_to root_path
		end
	end

	def activation
	end

	def offline_activation
		temp = nil
		if params[:activation_file]
			# Copy the uploaded file to a tempfile
			temp = ::Rex::Quickfile.new('activate')
			uploaded_io = params[:activation_file]

			begin
				while (buff = uploaded_io.read(1024*64))
					temp.write(buff)
				end
			rescue ::EOFError
			end

			temp.flush
		end

		# Just present the user with the form
		if not temp
			return
		end

		begin
			# Explicitly close the file to prevent locking issues
			path = temp.path
			temp.close rescue nil

			@license.activate_offline(path)
			if @license.activated? and not @license.error
				AuditLogger.admin "#{ip_user} - License offline activation. #{@license.as_json}"
				flash[:notice] = "Activation Successful"
				redirect_to root_path
			else
				flash[:error] = "Activation Failed: #{@license.error}"
			end
		rescue Exception => e
			flash[:error] = "Activation Failed: #{e.message}"
		end
	end

	def activate
		@product_key = params[:product_key].to_s.strip.upcase
		@product_key = nil if @product_key.empty?

		if @license.activated?
			error_redirect = licenses_path
		else
			error_redirect = {:action => 'activation'}
		end

		if params[:product_key] and not @product_key
			flash[:error] = "Product Key must be provided"
			redirect_to error_redirect
			return
		end

		# This handles the revert license mode
		if params[:revert] == "true"
			@license.revert
			if @license.activated? and not @license.error
				current_profile.settings["update_available"]   = nil
				current_profile.settings["update_proxy_error"] = nil
				current_profile.save
				AuditLogger.admin "#{ip_user} - License activated. #{@license.as_json}"
				flash[:notice] = "Activation Successful: Please restart your Metasploit instance"
				redirect_to licenses_path
			else
				flash[:error] = "Activation Failed: #{@license.error}"
				redirect_to error_redirect
			end
			return
		end

		proxy_params = if params[:use_proxy]
			@current_user.update(current_user_params)
			{ :proxy_host => @current_user.http_proxy_host,
			:proxy_port => @current_user.http_proxy_port,
			:proxy_user => @current_user.http_proxy_user,
			:proxy_pass => @current_user.http_proxy_pass }
		else
			{}
		end

		proxy_params['product_key'] = @product_key if @product_key

		begin
			@license.activate(proxy_params)
			if @license.activated? and not @license.error
				# TODO: Schedule background update check
				current_profile.settings["update_available"]   = nil
				current_profile.settings["update_proxy_error"] = nil
				current_profile.save
				AuditLogger.admin "#{ip_user} - License activated. #{@license.as_json}"
				flash[:notice] = "Activation Successful: Please restart your Metasploit instance"
				redirect_to root_path
			else
				flash[:error] = "Activation Failed: #{@license.error}"
				redirect_to error_redirect
			end
		rescue Exception => e
			flash[:error] = "Activation Failed: #{e.message}"
			redirect_to error_redirect
		end
	end

private

	def load_license
		@license = License.get
	end

	def load_product_key
		@product_key  = params[:product_key] || @license.product_key || ""
	end
end

