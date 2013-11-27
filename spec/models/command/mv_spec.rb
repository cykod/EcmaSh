require "spec_helper"

describe Command::Mv  do

  let(:user) { create :user }
  let(:other_user) { create :other_user }

  def run_mv_command(*args)
    Command.run(user,:mv,{},args)
  end

  describe "#run" do

    let(:dir) { create :directory_node, user: user }
    let!(:subdir1) { create :directory_node, parent: dir, user: user,  name: "DirA" }
    let!(:subdir2) { create :directory_node, parent: dir, user: user, name: "DirB"  }
    let!(:file) { create :file_node, parent: dir, user: user }

    it "moves files into existing directories"

    it "moves directories into existing directories"

    it "moves directories to new names"

    it "moves files to new names"

    it "updates the file on disk when it's moved"

  end
end
