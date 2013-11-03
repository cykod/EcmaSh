require "spec_helper"

describe Command::Ls do

  let(:user) { create :user }
  let(:other_user) { create :other_user }

  def run_ls_command(arg)
    Command.run(user,:ls,{},[ arg ])
  end

  describe "#run" do

    let(:dir) { create :directory_node, user: user }
    let!(:subdir1) { create :directory_node, parent: dir, user: user,  name: "DirA" }
    let!(:subdir2) { create :directory_node, parent: dir, user: user, name: "DirB"  }
    let!(:file) { create :file_node, parent: dir, user: user }

    it "returns all the children of a directory in order" do
      result = run_ls_command(dir.fullpath)
      result[0]['fullpath'].should == subdir1.fullpath
      result[1]['fullpath'].should == subdir2.fullpath
      result[2]['fullpath'].should == file.fullpath
    end

    it "returns the file if it's there" do
      result = run_ls_command(file.fullpath)
      result[0]['fullpath'].should == file.fullpath
    end

    it "returns the current directory without any args" do
      result = Command.run(user,:ls,{ CWD: dir.fullpath },[ ])
      result[0]['fullpath'].should == subdir1.fullpath
    end
  end
end
