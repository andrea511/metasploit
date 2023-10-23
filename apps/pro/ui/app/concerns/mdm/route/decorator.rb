module Mdm::Route::Decorator
	def to_s
		"#{subnet}/#{netmask} => Mdm::Session #{session.id}"
	end
end
