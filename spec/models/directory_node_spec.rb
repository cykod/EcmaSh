require 'spec_helper'

describe DirectoryNode do
  

  context "#update_children_path" do

    let(:dir1) { create :directory_node }
    let(:dir2) { create :directory_node, parent: dir1 }
    
    it "updates the child's fullpath" do
      dir1.update_attributes(name: "new-name")

      dir2.reload.fullpath.should == "/new-name/#{dir2.name}"
    end

  end
end
