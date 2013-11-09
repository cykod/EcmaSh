require 'spec_helper'

describe DirectoryNode do
  

  describe "#update_children_path" do

    let(:dir1) { create :directory_node }
    let(:dir2) { create :directory_node, parent: dir1 }
    
    it "updates the child's fullpath" do
      dir1.update_attributes(name: "new-name")

      dir2.reload.fullpath.should == "/new-name/#{dir2.name}"
    end

  end

  describe ".home_node" do

    it "creates the home node if there isn't one" do
      expect { 
        DirectoryNode.home_node
      }.to change { DirectoryNode.count }.by(1)
    end

    it "has a path of /home" do
      DirectoryNode.home_node.fullpath.should == "/home"
    end

    it "returns the same node if it already exists" do
      DirectoryNode.home_node.should == DirectoryNode.home_node
    end

  end


end
