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

    it "mv files into existing directories" do
      expect { 
        result = run_mv_command(file.fullpath, subdir1.fullpath)
        result[0]["fullpath"].should include(subdir1.fullpath)
      }.to change { FileNode.count }.by(0)
    end

  end
end
