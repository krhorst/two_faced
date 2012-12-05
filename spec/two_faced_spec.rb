require "spec_helper"

describe TwoFaced do

  after(:each) do
    cleanup_db
  end

  before(:each) do
    @record = ModelToOverride.create(:name => "Original Name", :description => "Original Description")
  end

  it "should show the original name normally" do
    @record.name.should eq("Original Name")
  end

  describe "with mobile override added" do

    before(:each)  do
      @record.overrides.create(:field_name => "name", :field_value => "New Name", :context_name => "mobile")
    end

    it "should still show the original name if not scoped" do
      @record.name.should eq("Original Name")
    end

    it "should have a different overridden_name if scoped for mobile" do
      mobile_version = ModelToOverride.for_context("mobile").first
      mobile_version.overridden_name.should eq("New Name")
      mobile_version.name.should eq("Original Name")
    end

    it "should overwrite the name property if passing the overwrite parameter" do
      overwritten_mobile_version = ModelToOverride.for_context("mobile", :overwrite => true).first
      overwritten_mobile_version.overridden_name.should eq("New Name")
      overwritten_mobile_version.name.should eq("New Name")
    end

    it "should give read only error if attempting to save an overridden record" do
      overwritten_mobile_version = ModelToOverride.for_context("mobile", :overwrite => true).first
      expect { overwritten_mobile_version.save }.to raise_error
    end

    it "should show original name if override does not match scope" do
      facebook_version = ModelToOverride.for_context("facebook", :overwrite => true).first
      facebook_version.name.should eq("Original Name")
      facebook_version.overridden_name.should eq("Original Name")
    end

    it "should create a property with a custom prefix" do
      custom_prefixed_version = ModelToOverride.for_context("mobile", :attribute_prefix => "custom").first
      custom_prefixed_version.name.should eq("Original Name")
      custom_prefixed_version.custom_name.should eq("New Name")
    end

  end

end