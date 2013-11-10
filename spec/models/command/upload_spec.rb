require "spec_helper"

describe Command::Upload do


  let(:user) { create :user }
  let(:other_user) { create :other_user }

  let(:image_file) {fixture_file_upload("images/rails.png","image/png") }
  let(:text_file) { fixture_file_upload("text/sample_file.txt", "text/plain") }

  def run_upload_command(directory,files)
    Command.run(user,:upload,{ CWD: directory }, files)
  end

  describe"#run" do
    
    let(:dir) { create :directory_node, user: user }
    let!(:subdir1) { create :directory_node, parent: dir, user: user,  name: "DirA" }
    let!(:subdir2) { create :directory_node, parent: dir, user: user, name: "DirB"  }
    let!(:file) { create :file_node, parent: dir, user: user }

    it "raises a cant write error without write access" do
      result = run_upload_command("/some/random/directory", [ image_file ])
      result.is_a?(CantWriteError).should be_true
    end

    it "uploads the file with write access" do
      expect { 
        run_upload_command(subdir1.fullpath, [ image_file ])
      }.to change { FileNode.count }.by(1)
    end

    it "uploads multiple files with write access" do 
      expect { 
        run_upload_command(subdir1.fullpath, [ image_file, text_file ])
      }.to change { FileNode.count }.by(2)
    end

    it "changes the argv from actual files to names" do
      run_upload_command(subdir1.fullpath, [ image_file, text_file ])

      c = Command.last
      c.argv.should == ["rails.png", "sample_file.txt"]
    end
  end


end
