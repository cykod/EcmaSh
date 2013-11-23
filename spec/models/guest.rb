require "spec_helper"

describe Guest do

  context "#generate!" do

    it "should create a new user" do
      expect { Guest.generate! }.to change { User.count }.by(1)
    end

    it "should be valid" do
      Guest.generate!.should be_valid
    end

    it "shouldn't create two users with the same name" do
      Guest.generate!.username.should_not == Guest.generate!.username
    end

  end

end
