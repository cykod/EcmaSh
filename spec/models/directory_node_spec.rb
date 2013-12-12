require 'spec_helper'

describe DirectoryNode do
  

  describe "#update_children_path" do

    let(:dir1) { create :directory_node }
    let(:dir2) { create :directory_node, parent: dir1 }
    
    it "updates the child's fullpath" do
      dir1.update_attributes(name: "new-name")

      dir2.reload.fullpath.should == "/new-name/#{dir2.name}"
    end

  end

  describe ".home_node" do

    it "creates the home node if there isn't one" do
      expect { 
        DirectoryNode.home_node
      }.to change { DirectoryNode.count }.by(1)
    end

    it "has a path of /home" do
      DirectoryNode.home_node.fullpath.should == "/home"
    end

    it "returns the same node if it already exists" do
      DirectoryNode.home_node.should == DirectoryNode.home_node
    end

  end


  describe ".download" do
    let(:user) { create :user }
    let(:parent_dir) { create :directory_node, user: user }

    
    it "downloads a file and creates a new node" do
      fixture = fixture_file_upload("images/rails.png", "image/png")
      FakeWeb.register_uri(:get, "http://www.google.com/rails.png", body: fixture.read)

      expect { 
        parent_dir.download("http://www.google.com/rails.png")
      }.to change { FileNode.count }.by(1)
    end

    it "doesn't create a file with a 404" do
      FakeWeb.register_uri(:get, "http://www.google.com/rails.png", status: 404)

      expect { 
        parent_dir.download("http://www.google.com/rails.png")
      }.to change { FileNode.count }.by(0)
    end

  end

  describe "#empty_file"

end
