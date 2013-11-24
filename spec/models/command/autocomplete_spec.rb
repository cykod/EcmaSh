require "spec_helper"

describe Command::Autocomplete do

  let(:user) { create :user }
  let(:other_user) { create :other_user }

  def run_autocomplete_command(arg,cwd)
    Command.run(user,:autocomplete,{ CWD: cwd},[ arg ])
  end

  describe "#run" do

    let(:dir) { create :directory_node, user: user }
    let!(:subdir1) { create :directory_node, parent: dir, user: user,  name: "DirA" }
    let!(:subdir2) { create :directory_node, parent: dir, user: user, name: "DirB"  }
    let!(:file) { create :file_node, parent: dir, user: user, name: "tester.txt" }

    it "returns for DirA and DirB" do
      result = run_autocomplete_command("Dir", dir.fullpath)
      result[0]['name'].should == subdir1.name
      result[1]['name'].should == subdir2.name
    end

    it "just a file that matches" do
      result = run_autocomplete_command("tester.txt", dir.fullpath)
      result.length.should == 1
      result[0]['name'].should == file.name
    end

    it "returns an invalid file unless there's a directory I can read" do
      result = run_autocomplete_command("tester.txt", "/tester")
      result.should be_instance_of InvalidFileError
    end

    it "returns nothing if there's no matching file" do
      result = run_autocomplete_command("testerma.txt", dir.fullpath)
      result.should be_nil
    end

    it "returns everything in the directory if the search ends in a /" do
      result = run_autocomplete_command("./", dir.fullpath)
      result.length.should == 3
    end

  end
end
