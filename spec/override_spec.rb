require "spec_helper"

describe Override do

  before(:each) do
    @example_model = ModelToOverride.create({:name => "Name", :description => "Description"})
    @valid_override_attributes = {
        :context_name => "website",
        :field_name => "name",
      :field_value => "New Name" }
  end

  it "should create an override given valid attributes" do
    @example_model.overrides.new(@valid_override_attributes)
    @example_model.should be_valid
  end

  it "should not create an override without a field name" do
    no_field_attributes = @valid_override_attributes.merge(:field_name => "")
    @example_model.overrides.new(no_field_attributes).should_not be_valid
  end

  it "should not create an override without a context name" do
    no_context_attributes = @valid_override_attributes.merge(:context_name => "")
    @example_model.overrides.new(no_context_attributes).should_not be_valid
  end

  it "should not create an override if the field name does not exist on the model" do
    no_field_attributes = @valid_override_attributes.merge(:field_name => "nonexistent_field")
    @example_model.overrides.new(no_field_attributes).should_not be_valid
  end


end