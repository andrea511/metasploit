# This module can be mixed into a TaskConfig to allow the use of ActiveRecord-style
# association macros.
#
# @example Attach a Report to a TaskConfig
#   class TaskConfig
#     include TaskConfig::Associations
#
#     has_one :report
#   end
#
#   task_config.report = report
#   task_config.report_id  #=> 1
#
module TaskConfig::Associations
  extend ActiveSupport::Concern

  module ClassMethods
    # Creates reader and writer methods for attaching an ActiveRecord object to
    # the `TaskConfig`. Methods to read and write the object or the object's id are
    # defined.
    #
    # @param name [String] the name of the association
    # @param options [Hash] optional arguments used to build the association
    # @option options [String] :class the class of the associated object, if it
    #   cannot be inferred from the name of the association (i.e. `Mdm::Workspace`)
    def has_one(name, options = {})
      create_attr_readers(name)
      define_object_writer(name)
      define_object_id_writer(name, class: options[:class])
    end

    private

    # Creates attribute readers on the class for the object and its id.
    #
    # @param name [String] the name of the association
    def create_attr_readers(name)
      class_eval "attr_reader :#{name}"
      class_eval "attr_reader :#{name}_id"
    end

    # Creates a writer method for the associated object.
    #
    # @example
    #   has_one :report
    #
    #   task_config.report = report
    #
    # @param name [String] the name of the association
    def define_object_writer(name)
      define_method "#{name}=" do |object|
        instance_variable_set("@#{name}", object)

        if object.nil?
          instance_variable_set("@#{name}_id", nil)
        else
          instance_variable_set("@#{name}_id", object.id)
        end
      end
    end

    # Creates a writer method for the associated object's id.
    #
    # @example
    #   has_one :report
    #
    #   task_config.report_id = report.id
    #
    # @param name [String] the name of the association
    # @param options [Hash] optional arguments used to build the association
    # @option options [String] :class the class of the associated object, if it
    #   cannot be inferred from the name of the association (i.e. `Mdm::Workspace`)
    def define_object_id_writer(name, options = {})
      # Determine which class to use when finding the object.
      klass = options[:class] || name.to_s.capitalize.constantize

      define_method "#{name}_id=" do |object_id|
        if object_id.present?
          object_id = object_id.to_i
          object = klass.find(object_id)
        else
          object_id = nil
          object = nil
        end

        instance_variable_set("@#{name}_id", object_id)
        instance_variable_set("@#{name}", object)
      end
    end
  end
end