require "rails"
require "active_record"
require "two_faced"

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 0) do

    create_table :overrides do |t|
      t.string :context_name
      t.string :overrideable_type
      t.integer :overrideable_id
      t.string :field_name
      t.text :field_value

      t.timestamps
    end

    create_table :model_to_overrides do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end


setup_db

def cleanup_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.execute("delete from #{table}")
  end
end

class ModelToOverride < ActiveRecord::Base
  attr_accessible :name, :description
  acts_as_overrideable
end


load(File.expand_path( 'app/models/override.rb'))