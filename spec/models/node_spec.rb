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

  context "#parent_ids" do

    let(:dir1) { create :directory_node }
    let(:dir2) { create :directory_node, parent: dir1 }
    let(:dir3) { create :directory_node, parent: dir2 }
    let(:file) { create :file_node, parent: dir3 }


    let(:dir_other) { create :directory_node }
    

    it "sets the full hierarchy of parent ids" do
      file.parent_ids.should == [ dir1.id, dir2.id, dir3.id ]
    end

    it "updates parent_ids if a directory is moved" do
      dir2.parent = dir_other
      dir2.save
      file.parent_ids.should == [ dir_other.id, dir2.id, dir3.id ]
    end
  end

  describe".fetch" do
    let(:dir1) { create :directory_node }
    let(:dir2) { create :directory_node, parent: dir1 }
    let(:dir3) { create :directory_node, parent: dir2 }
    
    it "returns the node" do
      dir3.should == Node.fetch(dir3.fullpath)
    end

  end
end
