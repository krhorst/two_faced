require 'rails/generators/active_record'

module TwoFaced
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      desc "Installs TwoFaced and generates the necessary migrations"

      argument :name, :type => :string, :default => "create_migrations"

      def self.source_root
        File.expand_path("../templates", __FILE__)
      end


      def create_migrations
        Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
          name = File.basename(filepath)
          migration_template "migrations/#{name}", "db/migrate/#{name.gsub(/^\d+_/, '')}"
          sleep 1
        end
      end

    end
  end
end
