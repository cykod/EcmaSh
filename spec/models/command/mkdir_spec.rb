require "spec_helper"

describe Command::Mkdir do

  let(:user) { create :user }
  let(:other_user) { create :user }

  def run_mkdir_command(cwd, arg)
    Command.run(user,:mkdir,{ "CWD" => cwd },[ arg ])
  end

  describe "#run" do

    let(:dir) { create :directory_node, user: user }
    let!(:subdir1) { create :directory_node, parent: dir, user: user,  name: "DirA" }
    let!(:subdir2) { create :directory_node, parent: dir, user: user, name: "DirB"  }
    let!(:file) { create :file_node, parent: dir, user: user }

    let(:other_dir) { create :directory_node, user: other_user }

    it "doesn't allow you to create a random directory name" do
      result = run_mkdir_command(dir.fullpath, "/tester/seomthing/dasgad")
      result.is_a?(InvalidFileError).should be_true
    end

    it "doesn't allow you to create directories in other user's directories" do
      result = nil

      expect { 
        result = run_mkdir_command(dir.fullpath, other_dir.fullpath + "/tester")
      }.to change { DirectoryNode.count }.by(1)

      result.is_a?(InvalidFileError).should be_true
    end

    it "allows you to create directories in your own directories" do
      expect { 
        result = run_mkdir_command(dir.fullpath, "tester")
      }.to change { DirectoryNode.count }.by(1)
    end

    it "does not allow you to create directories in files" do
      expect { 
        result = run_mkdir_command(dir.fullpath, file.fullpath + "/tester")
      }.to change { DirectoryNode.count }.by(0)
    end

  end
end
