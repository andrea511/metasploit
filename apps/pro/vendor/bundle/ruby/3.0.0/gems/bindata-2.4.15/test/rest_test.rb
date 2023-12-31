#!/usr/bin/env ruby

require File.expand_path(File.join(File.dirname(__FILE__), "test_helper"))

describe BinData::Rest do
  let(:obj) { BinData::Rest.new }

  it "initial state" do
    _(obj).must_equal ""
  end

  it "reads till end of stream" do
    data = "abcdefghij"
    _(obj.read(data)).must_equal data
  end

  it "allows setting value for completeness" do
    obj.assign("123")
    _(obj).must_equal "123"
    _(obj.to_binary_s).must_equal_binary "123"
  end

  it "accepts BinData::BasePrimitive parameters" do
    rest = BinData::Rest.new(assert: "abc")
    _ {
      rest.read("xyz")
    }.must_raise BinData::ValidityError
  end
end
