class Override < ActiveRecord::Base
  attr_accessible :context_name, :field_name, :field_value, :overrideable_id, :overrideable_type

  belongs_to :overrideable, :polymorphic => true

  validates :field_name, :presence => true
  validates :context_name, :presence => true
  validate :field_name_exists_on_associated_model

  def field_name_exists_on_associated_model
    klass =  overrideable_type.constantize
    unless klass.attribute_names.include?(field_name)
      errors.add(:field_name, "must be an attribute of #{overrideable_type}")
    end
  end

end
