module Mdm::Ref::Decorator
	def link_info
		ctx_id, ctx_val = name.to_s.split("-", 2)
		if not ctx_val
			ctx_val = ctx_id
			ctx_id  = 'GENERIC'
		end
		[ ctx_id, ctx_val ]
	end

	def to_exploit
		MsfModule.find_by_ref *link_info
	end

	def to_s
		name.to_s
	end
end
