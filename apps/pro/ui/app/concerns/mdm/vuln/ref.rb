module Mdm::Vuln::Ref
  # Creates new Mdm::Ref associations for a newly created Mdm::Vuln.
	#
	# ref_attributes - The Array of Hashes of attributes for the Refs to be
	#                  created.
	def new_ref_attributes=(ref_attributes)
		ref_attributes.each do |attributes|
			unless attributes[:name].blank?
				ref = Mdm::Ref.find_by_name(attributes[:name])
				if ref
					refs << ref
				else
					refs.build(attributes)
				end
			end
		end
	end

	# Updates and deletes Refs for this Mdm::Vuln.
	#
	# ref_attributes - The Array of Hashes of attributes for the Refs to be
	#                  created.
	#
	# Returns nothing.
	def existing_ref_attributes=(ref_attributes)
		existing_refs = refs

		refs.reject(&:new_record?).each do |ref|
			attributes = ref_attributes[ref.id.to_s]
			if attributes
				ref.attributes = attributes
			else
				refs.delete(ref)
			end
		end
	end
end