require 'spec_helper'

describe Node do
  

  context "#set_full_path" do

    let(:dir1) { create :directory_node }
    let(:dir2) { create :directory_node, parent: dir1 }
    
    it "sets the full path" do
      dir2.fullpath.should == "/#{dir1.name}/#{dir2.name}"
    end

  end

  context "#name" do

    it "doesn't allow spaces" do
      node = build :directory_node, name: "tester rama"
      node.should have(1).errors_on(:name)
    end

    it "doesn't allow special characters" do
      node = build :directory_node, name: "tester$$"
      node.should have(1).errors_on(:name)
    end

    it "does allow numbers and dashes" do
      node = build :directory_node, name: "tester1235-4352.test"
      node.should have(0).errors_on(:name)
    end
  end
end
