require "spec_helper"

describe CommandsController do
  render_views

  context "no user" do

    it "returns a 403 not authorized if not logged in" do
      post :create, id: "ls", argv: [ "/home" ]
      response.status.should == 403
    end


  end


  context "valid user" do

    let(:user) { create :user }
    before { sign_in user }

    describe "#create" do

      context "invalid arguments " do

        it "doesn't create a new command if the command is invalid" do
          expect { 
            post :create, id: "wtfer"
          }.to change { Command.count }.by(0)
        end

        it "creates a new command if the command is valid" do
          expect { 
            post :create, id: "ls", argv: [ "/home/testerama" ]
          }.to change { Command.count }.by(1)
          Command.last.should_not be_successful
        end

        it "returns a 406 with invalid arguments" do
          post :create, id: "ls", argv: [ "/home/testerama" ]
          response.status.should == 406
        end
      end

      context "valid arguments" do

        let(:dir_parent) { create :directory_node, user: user }
        let(:dir_child) { create :directory_node, parent: dir_parent, user: user }
        let(:file) { create :file_node, parent: dir_parent, user: user }

        let(:dir_other) { create :directory_node }

        it "returns a 200" do
          post :create, id: "ls", argv: [ file.fullpath ]
          response.status.should == 200
        end

        it "ls command returns the file requested" do
          post :create, id: "ls", argv: [ file.fullpath ]
          response.body.should include(file.fullpath)
        end

        it "creates a command for the user" do

          expect { 
            post :create, id: "ls", argv: [ file.fullpath ]
          }.to change { user.commands.successful.count }.by(1)

        end

      end
    end

  end


end
