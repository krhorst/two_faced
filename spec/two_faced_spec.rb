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
      mobile_version = ModelToOverride.for_context("mobile") {|model| model.first }
      mobile_version.overridden_name.should eq("New Name")
      mobile_version.name.should eq("Original Name")
    end

    it "should overwrite the name property if passing the overwrite parameter" do
      overwritten_mobile_version = ModelToOverride.for_context("mobile", :overwrite => true) {|model| model.first }
      overwritten_mobile_version.overridden_name.should eq("New Name")
      overwritten_mobile_version.name.should eq("New Name")
    end

    it "should give read only error if attempting to save an overridden record" do
      overwritten_mobile_version = ModelToOverride.for_context("mobile", :overwrite => true) {|model| model.first}
      expect { overwritten_mobile_version.save }.to raise_error
    end

    it "should not give an error if attempting to save a non-overridden record" do
      non_overwritten_mobile_version = ModelToOverride.for_context("mobile") {|model| model.first}
      expect { non_overwritten_mobile_version.save }.not_to raise_error
    end

    it "should show original name if override does not match scope" do
      facebook_version = ModelToOverride.for_context("facebook", :overwrite => true) {|model| model.first}
      facebook_version.name.should eq("Original Name")
      facebook_version.overridden_name.should eq("Original Name")
    end

    it "should create a property with a custom prefix" do
      custom_prefixed_version = ModelToOverride.for_context("mobile", :attribute_prefix => "custom") {|model| model.first }
      custom_prefixed_version.name.should eq("Original Name")
      custom_prefixed_version.custom_name.should eq("New Name")
    end

    it "should not affect the model's class on overwrite" do
      overwritten_mobile_version = ModelToOverride.for_context("mobile", :overwrite => true) {|model| model.first }
      non_overwritten_version = ModelToOverride.first
      non_overwritten_version.name.should eq("Original Name")
    end

    describe "with multiple records" do

      before(:each) do
        @record_2 = ModelToOverride.create(:name => "Second Name", :description => "Second Description")
      end

      it "should not only change the value of a record with an override added in a mixed collection" do
        all_results = ModelToOverride.for_context("mobile", :overwrite => true) {|model| model.all }
        overridden_first_result = all_results.first
        non_overridden_second_result = all_results.second
        overridden_first_result.name.should eq("New Name")
        non_overridden_second_result.name.should eq("Second Name")
      end

      it "should change both values if both have overrides" do
        @record_2.overrides.create(:field_name => "name", :field_value => "Second Record New Name", :context_name => "mobile")
        all_results = ModelToOverride.for_context("mobile", :overwrite => true) {|model| model.all }
        overridden_first_result = all_results.first
        non_overridden_second_result = all_results.second
        overridden_first_result.name.should eq("New Name")
        non_overridden_second_result.name.should eq("Second Record New Name")
      end


    end

  end

end