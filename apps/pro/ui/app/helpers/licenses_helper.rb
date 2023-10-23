module LicensesHelper
	# Determines an appropriate registration link message based on the state of 
	# the current license.
	#
	# Returns the String message.
	def registration_message
		if @license.community? && @license.activated? && !@license.expired?
			"Get a free, fully-featured trial version of Metasploit Pro."
		else
			"Choose the product that best meets your needs: Metasploit Pro or the free Metasploit Community Edition."
		end
	end

	def product_key_title
		if @license.registered? and @license.expired?
			"Your License Has Expired"
		else
			"Activate Your Metasploit License"
		end
	end

	def product_key_header
		if @license.community? && @license.activated?
			"Get Trial Key for Metasploit Pro"
		else
			"Get Your Product Key"
		end
	end

	def product_key_link_text
		if @license.community? && @license.activated?
			"GET METASPLOIT PRO TRIAL"
		else
			"GET PRODUCT KEY"
		end
	end

	# Choose a correct product key URL path based on the state of 
	# the current license.
	#
	# Returns the String message.
	def product_key_path
		if @license.community? && @license.activated?
			"metasploit-trial.jsp"
		else
			"metasploit.jsp"
		end
	end

	def product_param_name
		if @license.community? && @license.activated?
			"product"
		else
			"Product"
		end
	end
end
