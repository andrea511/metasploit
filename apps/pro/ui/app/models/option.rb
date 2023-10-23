class Option

	attr :name
	attr :type
	attr :required
	attr :advanced
	attr :evasion
	attr :desc
	attr :default
	attr :enums

	def initialize(attributes = {})
		@name     = attributes[:name]
		@type     = attributes[:type]
		@required = attributes[:required]
		@advanced = attributes[:advanced]
		@evasion  = attributes[:evasion]
		@desc     = attributes[:desc]
		@default  = attributes[:default]
		@enums    = attributes[:enums]
	end

	def advanced?
		advanced
	end

	def required?
		required
	end

	def evasion?
		evasion
	end
end

