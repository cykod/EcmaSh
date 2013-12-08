require "spec_helper"

describe Command::Cp  do

  let(:user) { create :user }
  let(:other_user) { create :other_user }

  describe "#run" do

    def run_cp_command(*args)
      Command.run(user,:cp,{ CWD: dir.fullpath },args)
    end

    let(:dir) { create :directory_node, user: user }
    let!(:subdir1) { create :directory_node, parent: dir, user: user,  name: "DirA" }
    let!(:subdir2) { create :directory_node, parent: dir, user: user, name: "DirB"  }
    let!(:file) { create :file_node, parent: dir, user: user }
    let!(:subdir1_file) { create :file_node, parent: subdir1, user: user }

    it "copies files into existing directories" do
      expect { 
        result = run_cp_command(file.fullpath, subdir1.fullpath)
        result[0]["fullpath"].should include(subdir1.fullpath)
      }.to change { FileNode.count }.by(1)
    end

    it "copies directories into existing directories with their children" do
      result = nil
      expect { 
        result = run_cp_command(subdir1.fullpath, subdir2.fullpath)
        result[0]["fullpath"].should include(subdir2.fullpath)
      }.to change { FileNode.count }.by(1)
      
      subdir2.reload
      subdir2.children.length.should == 1
      subdir2.children[0].name.should == subdir1.name
      subdir2.children[0].children.length.should == 1
      subdir2.children[0].children[0].name.should == subdir1_file.name
    end

    it "copies files to new names" do
      expect { 
        result = run_cp_command(file.fullpath, "newname.txt")
      }.to change { FileNode.count }.by(1)
      FileNode.last.name.should == "newname.txt"
    end

    it "overwrites an existing file" do
      expect { 
        result = run_cp_command(file.fullpath, subdir1_file.fullpath)
      }.to change { FileNode.count }.by(0)
      Node.where(id: subdir1_file.id).first.should be_nil

    end
  end

end
