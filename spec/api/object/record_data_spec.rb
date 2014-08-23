require "spec_helper.rb"

describe Responsys::Api::Object::RecordData  do

  context "Constructor params handling" do
    before(:each) do
      @data = [{ field1: "value11", field2: "value12" }, { field2: "value22", field3: "value23" }]
      @field_names = [:field1, :field2, :field3]
      @record1 = ["value11", "value12", ""]
      @record2 = ["", "value22", "value23"]

      @object = Responsys::Api::Object::RecordData.new(@data)
    end

    it "should handle transform the constructor params" do
      expect(@object.field_names).to eq(@field_names)
    end

    it "should transform correctly the object to the api representation" do
      expect(@object.to_api).to eq({ fieldNames: @field_names, records: [{ fieldValues: @record1 }, { fieldValues: @record2 }] })
    end

    it "should raise an exception if the constructor parameter is not an array" do
      expect{Responsys::Api::Object::RecordData.new("")}.to raise_exception(Responsys::Exceptions::ParameterException, "The data you provided is not an array")
    end
  end

end