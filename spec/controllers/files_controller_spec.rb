require "spec_helper"

describe FilesController do
  render_views true

  let(:user) { create :user }
  before { sign_in user }

  let(:image_file) { fixture_file_upload("images/rails.png","image/png") }

  describe "#create" do

    it "returns a 404 if the users doesn't have write access" do
      post :create, directory:  "tester" , files: [ image_file ]
      response.status.should == 406
    end

    it "uploads the file and create new file node with write access" do
      directory = create :directory_node, name: "tester", 
                  user: user, parent: DirectoryNode.home_node

      expect { 
        post :create, directory: "tester" , files: [ image_file ]
      }.to change { FileNode.count }.by(1)
      response.status.should == 200
    end
  end

  describe "#show" do

    let(:directory) { create :directory_node, name: "tester", user: user, parent: DirectoryNode.home_node }


    let(:image_file) { FileNode.create(file: fixture_file_upload("images/rails.png","image/png"), parent: directory) }
    let(:text_file) { FileNode.create(file: fixture_file_upload("text/sample_file.txt", "text/plain"), parent: directory ) }

    it "returns a 404 without a valid file" do
      get :show, directory: "tester"
      response.status.should == 404
    end

    it "redirects to the file for a image file" do
      image_file

      get :show, directory: "tester/rails.png"
      response.should redirect_to(image_file.file(:original))
    end

    it "renders the text content directly" do
      text_file

      get :show, directory: "tester/sample_file.txt"
      response.body.should include("emergency broadcast system")
    end
  end
end
