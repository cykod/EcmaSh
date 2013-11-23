require "spec_helper"

describe GuestsController do

  let(:json_body) { JSON.parse(response.body) }

  context "#create" do

    it "creates a new user" do
      expect { post :create }.to change { User.count }.by(1)
    end

    it "returns the JSON for the created user" do
      post :create
      u = User.last
      json_body["username"].should == u.username
    end

  end

end
