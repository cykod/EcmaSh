require "spec_helper"

describe FilesController do
  render_views true

  let(:user) { create :user }
  before { sign_in user }

  let(:image_file) { fixture_file_upload("images/rails.png","image/png") }

  describe "#create" do

    it "should return a 404 if the users doesn't have write access" do
      post :create, directory:  "tester" , files: [ image_file ]
      response.status.should == 406
    end

    it "should upload the file and create new file node with write access" do
      directory = create :directory_node, name: "tester", 
                  user: user, parent: DirectoryNode.home_node

      expect { 
        post :create, directory: "tester" , files: [ image_file ]
      }.to change { FileNode.count }.by(1)
      response.status.should == 200
    end
    
  end
end
