require "spec_helper"

describe Command::Show do

  let(:user) { create :user }
  let(:other_user) { create :other_user }

  def run_show_command(arg)
    Command.run(user,:show,{},[ arg ])
  end

  describe "#run" do

    let(:directory) { create :directory_node, name: "tester", user: user, parent: DirectoryNode.home_node }

    let(:image_file) { FileNode.create(file: fixture_file_upload("images/rails.png","image/png"), parent: directory) }
    let(:text_file) { FileNode.create(file: fixture_file_upload("text/sample_file.txt", "text/plain"), parent: directory ) }

    let(:other_directory) { create :directory_node, name: "other", parent: DirectoryNode.home_node, lock_level: Node::SECRET }
    let(:other_file) {  FileNode.create(file: fixture_file_upload("text/sample_file.txt", "text/plain"), parent: other_directory ) }

    it "shows an image file without content" do
      result = run_show_command(image_file.fullpath)
      result["image"].should be_true
      result["name"].should == "rails.png"
      result["content"].should be_nil
    end

    it "shows an text file with content" do
      result = run_show_command(text_file.fullpath)
      result["image"].should be_false
      result["name"].should == "sample_file.txt"
      result["content"].should_not be_nil
    end

    it "returns an invalid file error if I can't see the file" do
      result = run_show_command(other_file.fullpath)
      result.should be_instance_of(InvalidFileError)
    end


  end
end
