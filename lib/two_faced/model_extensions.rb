module TwoFaced

  module ModelExtensions

    def self.included(base)
      base.attr_accessible :overrides_attributes
      base.has_many :overrides, :as => :overrideable, :dependent => :destroy
      base.accepts_nested_attributes_for :overrides
      base.extend(ClassMethods)
    end

    module ClassMethods

      def for_context(context, options = {}, &block)
        options = {
          :attribute_prefix => "overridden",
          :overwrite => false
        }.merge(options)

        @context = context
        includes(:overrides)
        results = block.call(self)
        [*results].each do |result|
          result.add_properties_to_object!(context, options)
        end
        results
      end

    end

    def add_properties_to_object!(context, options)

      @overwrite_attribute_prefix = options[:attribute_prefix]

      overrides.where("context_name" => context).each do |override|
        (class << self; self; end).class_eval do
          override_long_name = "#{options[:attribute_prefix]}_#{override.field_name}"
          define_method("#{override_long_name}") { override.field_value }
        end

        if options[:overwrite] == true
          send "#{override.field_name}=", override.field_value
          send "readonly!"
        end
      end
      self
    end


    def method_missing(method_name, *args)
      prefix = "#{@overwrite_attribute_prefix}_"
      if method_name.to_s[prefix] != nil
        original_method = method_name.to_s.sub(prefix, "")
        send original_method
      else
        super
      end

    end


  end
end
