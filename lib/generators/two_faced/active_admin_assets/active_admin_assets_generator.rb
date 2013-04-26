require 'rails/generators/active_record'

module TwoFaced
  module Generators
    class ActiveAdminAssetsGenerator < ActiveRecord::Generators::Base
      desc "Adds references to css and javascript files used for custom override input"

      argument :name, :type => :string, :default => "move_active_admin_assets"

      def move_active_admin_assets
        inject_into_file "app/assets/javascripts/active_admin.js", :after => "//= require active_admin/base" do
          "\n//= require active_admin_tabbed_override"
        end
        inject_into_file "app/assets/stylesheets/active_admin.css.scss", :after => "@import \"active_admin/base\";" do
          "\n@import \"active_admin_tabbed_override\";"
        end
      end

    end
  end
end



