require "spec_helper"


describe Domain do

  let(:domain) { create :domain }

  describe ".base_domain?" do
    it "returns false for random domains" do
      Domain.base_domain?("testerama.com").should be_false
    end

    it "returns true for valid base domains" do
      Domain.base_domain?("www.ecmash.com").should be_true

    end
  end

  describe ".base_directory" do

    it "grabs the directory if valid" do
      Domain.base_directory(domain.name).should == domain.directory_node
    end

    it "returns nil if invalid" do
      Domain.base_directory("something" + domain.name).should be_nil
    end
  end

end
