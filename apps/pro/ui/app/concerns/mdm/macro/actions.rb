module Mdm::Macro::Actions
	def add_action(mname, options={})
	  if self.actions.kind_of? Array
		  self.actions << {:module => mname, :options => options}
		else
		  self.actions = [{:module => mname, :options => options}]
		end
		self.save!
	end
end