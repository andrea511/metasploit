class UpdateOffline

	attr :current_version
	attr :version
	attr :info
	attr :error

	def initialize()
		@current_version = License.get.product_revision
		@version = 'New Update'
		@info    = 'Offline Update Package'
	end

	def up_to_date?
		false
	end

	def apply(path)
		c = Pro::Client.get
		r = c.call("pro.update_install_offline", path)
		if (r["result"] == "failed")
			@error = r["reason"]
			return false
		else
			@error = nil
			return true
		end
	end

	def self.supported?
		!File.exist?(Rails.root.join('../.apt'))
	end
end

