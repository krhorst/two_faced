class CreateOverrides < ActiveRecord::Migration
  def change
    create_table :overrides do |t|
      t.string :context_name
      t.string :overrideable_type
      t.integer :overrideable_id
      t.string :field_name
      t.text :field_value

      t.timestamps
    end
    add_index :overrides, :context_name
    add_index :overrides, :overrideable_type
    add_index :overrides, :overrideable_id
    add_index :overrides, :field_name
  end
end
