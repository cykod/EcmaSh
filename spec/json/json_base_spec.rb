require "spec_helper"


describe JSONBase do

  it "should raise a no method error with an invalid method" do
    base  = JSONBase.new({})

    expect { base.tester }.to raise_error(NoMethodError)
  end
end
