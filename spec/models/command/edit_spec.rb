require "spec_helper"

describe Command::Edit do

   let(:user) { create :user }
   let(:directory) { create :directory_node, name: "tester", user: user, parent: DirectoryNode.home_node }

    let(:image_file) { FileNode.create(file: fixture_file_upload("images/rails.png","image/png"), parent: directory) }
    let(:text_file) { FileNode.create(file: fixture_file_upload("text/sample_file.txt", "text/plain"), parent: directory ) }


  def run_edit_command(arg)
    Command.run(user,:edit,{},[ arg ])
  end

  it "allows editing of existing text files" do
    result = run_edit_command(text_file.fullpath)
    result["fullpath"].should == text_file.fullpath
  end

  it "doesn't allow editing of image files" do
    result = run_edit_command(image_file.fullpath)
    result.should be_instance_of InvalidFileError
  end

  it "doesn't allow editing of directories" do
    result = run_edit_command(directory.fullpath)
    result.should be_instance_of InvalidFileError
  end

  it "does allow creation of files in a valid directory" do
   file_path = directory.fullpath + "/mytest.txt"
   result = run_edit_command(file_path)
   result["fullpath"].should == file_path
  end


  
end

