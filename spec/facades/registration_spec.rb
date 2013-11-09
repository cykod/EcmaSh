require "spec_helper"


describe Registration do

  describe "#initialize" do
    it "accepts an id as a username" do
      Registration.new(id: "tester").username.should == "tester"
    end

    it "accepts a username as username" do
      Registration.new(username: "tester").username.should == "tester"
    end

    it "accepts password and email" do
      r = Registration.new(password: "testy", email: "goober")
      r.password.should == 'testy'
      r.email.should == 'goober'
    end
  end

  describe "email validations" do

    it "doesn't accept usernames with spaces" do
      Registration.new(id: "test mctest").should have(1).errors_on(:username)
    end

    it "doesn't accept usernames with special characters" do
      Registration.new(id: "test$mctest").should have(1).errors_on(:username)
    end

    it "does accept valid usernames" do
      Registration.new(id: "test.mctest").should have(0).errors_on(:username)
    end

    it "doesn't accept usernames that already exist" do
      create  :user, username: "tester"
      Registration.new(id: "tester").should have(1).errors_on(:username)
    end
  end

  describe "#register!" do

    subject {  Registration.new(username: "tester", password: "tester") }

    # make sure we already have /home
    before { DirectoryNode.home_node }
                
    it "creates a user" do
      expect { subject.register! }.to change { User.count }.by(1)
    end
    
    it "creates a users home directory" do
      expect { subject.register! }.to change { DirectoryNode.count }.by(1)
    end
  end



end
