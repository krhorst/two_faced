module TwoFaced

  module ModelExtensions

    def self.included(base)
      base.attr_accessible :overrides_attributes
      base.has_many :overrides, :as => :overrideable, :dependent => :destroy
      base.accepts_nested_attributes_for :overrides
      base.after_find :get_overrides_for_context
      base.extend(ClassMethods)
    end

    module ClassMethods

      @overwrite_attribute_prefix = "overridden"

      def context
        @context
      end

      def overwrite_attribute_prefix
        @overwrite_attribute_prefix
      end

      def overwrite_attributes?
        @overwrite_attributes
      end

      def for_context(context, options = {})
        options = {
          :attribute_prefix => "overridden",
          :overwrite => false
        }.merge(options)

        @context = context
        includes(:overrides)
        @overwrite_attributes = options[:overwrite]
        @overwrite_attribute_prefix = options[:attribute_prefix]
        self
      end


    end

    def get_overrides_for_context
      klass = self.class
      self.overrides.where("context_name" => klass.context).each do |override|
        singleton_class.class_eval { attr_accessor "#{klass.overwrite_attribute_prefix}_#{override.field_name}" }
        send "#{klass.overwrite_attribute_prefix}_#{override.field_name}=", override.field_value
        if self.class.overwrite_attributes?
          send "#{override.field_name}=", override.field_value
          send "readonly!"
        end
      end
      self
    end

    def method_missing(method_name, *args)
      prefix = "#{self.class.overwrite_attribute_prefix}_"
      if method_name.to_s[prefix] != nil
        original_method = method_name.to_s.sub(prefix, "")
        send original_method
      else
        super
      end

    end

  end
end
