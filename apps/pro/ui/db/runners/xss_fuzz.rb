#
# Fills every :string or :text field in the DB with javascript
#   to check for XSS leaks or injections.
#

def all_models
  Rails.application.eager_load!
  ApplicationRecord.descendants
end

FIELD_BLACKLIST = {
  'Apps::App' => ['symbol'],
  'Mdm::User' => ['username', 'password']
}

@x = 0
def xss_string
  '<script type="text/javascript">console.log("script injection '+(@x+=1).to_s+' ohhhh nooooooooo");</script>'
end

# add the deep_map method to Object to let us walk unknown data structures
class Object
  def deep_map(&block)
    if self.respond_to? :each_pair
      out = {}
      self.each_pair do |k, v|
        out[k] = v.deep_map(&block)
      end
      return out
    elsif self.respond_to? :each
      out = []
      self.each do |x|
        out << x.deep_map(&block)
      end
      return out
    else
      return block.call(self)
    end
  end
end

def limit_field(val, limit)
  if limit.present? and val.length > limit
    val[0...limit]
  else
    val
  end
end

all_models.each do |model|
  puts "Updating the #{model.name} model..."
  model.all.each do |model_instance|
    model.columns.each do |col|
      blacklisted_fields = FIELD_BLACKLIST[model.name]
      next if blacklisted_fields.present? and blacklisted_fields.include?(col.name.to_s)

      if (col.type == :string or col.type == :text) and col.sql_type != 'inet'
        val = model_instance.send("#{col.name}")
        if model.serialized_attributes.keys.include? col.name.to_s
          # walk the existing serialized data and replace everything with xss_strings
          if val.present?
            model_instance.send("#{col.name}=", val.deep_map { limit_field(xss_string, col.limit) })
          end
        else
          model_instance.send("#{col.name}=", limit_field(xss_string, col.limit))
        end
      end
    end
    begin
      model_instance.save(:validate => false)
    rescue ArgumentError => e
      # occurs when trying to save on the superclass of a polymorphic model
    rescue ActiveRecord::RecordNotUnique => e
      # we already have some data to test this, ignore it
    end
  end
end


pass = 'test12#$'
Mdm::User.create(:username => 'msfadmin', :password => pass, :password_confirmation => pass)
puts "Created user 'msfadmin' with password '#{pass}'."
