require "spec_helper"

describe Command::Cd do

  let(:user) { create :user }
  let(:other_user) { create :other_user }

  def run_cd_command(arg)
    Command.run(user,:cd,{},[ arg ])
  end

  describe "#run" do

    let(:dir) { create :directory_node, user: user }
    let!(:subdir1) { create :directory_node, parent: dir, user: user,  name: "DirA" }
    let!(:subdir2) { create :directory_node, parent: dir, user: user, name: "DirB"  }
    let!(:file) { create :file_node, parent: dir, user: user }

    let!(:other_dir) { create :directory_node, parent: dir, lock_level: Node::SECRET }

    it "cds to a valid directory" do
      result = run_cd_command(subdir2.fullpath)
      result['fullpath'].should == subdir2.fullpath
    end

    it "doesn't cd to invalid directories" do
      result = run_cd_command("/some/random/directory")
      result.is_a?(InvalidFileError).should be_true
    end

    it "doesn't cd to files" do
      result = run_cd_command(file.fullpath)
      result.is_a?(InvalidFileError).should be_true
    end

    it "doesn't cd to secret directories" do
      result = run_cd_command(other_dir.fullpath)
      result.is_a?(InvalidFileError).should be_true
    end

  end
end
