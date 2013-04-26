module Formtastic
  module Inputs

    class OverridestringInput
      include Base
      include Base::Placeholder

      def input_html_options
        {
            :cols => builder.default_text_area_width,
            :rows => builder.default_text_area_height
        }.merge(super)
      end


      def default_input(builder, method, input_html_options)
        builder.text_field(method, input_html_options)
      end

      def override_input
        :string
      end

      def to_html
        input_wrapping do
          editors = build_editors(@object)
          label_html << build_tabs(@object) <<
              editors
        end
      end

      def build_tabs(object)
        html = "<ul class='editor-tabs'><li class='active' data-editor-id='-1'>Default</li>"
        unless object.overrides.blank?
          html += object.overrides.select{|x| x.field_name == method.to_s}.map { |o| "<li data-editor-id='#{o.id}' class='#{o.valid? ? "" : "error"}'>#{o.context_name.blank? ? "*blank*" : o.context_name}</li>" }.join
        end

        js = "<li data-editor-id='NEW_RECORD' class='new'>"
        js += @builder.fields_for :overrides, object.overrides.new, :child_index => "NEW_RECORD",
                                  :class => "inputs has_many_fields" do |x|
          x.inputs do
            x.input :context_name, :input_html => {:class => "header-input"}, :label => false
            x.input :field_value, :class => "editor-NEW_RECORD", :as => override_input, :label => false
            x.input :field_name, :value => method, :as => :hidden
          end
        end
        js += "</li>"
        js = template.escape_javascript(js)
        js = template.link_to "+", "#", :"data-template" => js, :class => "button"

        html << js.html_safe

        html += "</ul>"
        html.html_safe
      end

      def build_editors(object)
        html = "<ul class='editors'><li class='active' data-editor-id='-1'>"
        html += default_input(builder, method, input_html_options)
        html += "</li>"
        object.overrides.select{|x| x.field_name == method.to_s}.each do |o|
          html += "<li data-editor-id='#{o.id}'>"
          html += @builder.fields_for :overrides, o,
                                      :class => "inputs has_many_fields",
                                      :for_options => {
                                          :child_index => "NEW_RECORD"
                                      } do |x|
            x.inputs do
              x.input :context_name, :input_html => {:class => "header-input"}, :label => false
              x.input :field_value, :label => false, :as => override_input
              x.input :field_name, :value => method, :as => :hidden
            end
          end
          html += "</li>"
        end
        html += "</ul>"
        html.html_safe
      end

    end


    class OverridetextareaInput < Formtastic::Inputs::OverridestringInput

      def default_input(builder, method, input_html_options)
        builder.text_area(method, input_html_options)
      end

      def override_input
        :text
      end

    end


  end
end
