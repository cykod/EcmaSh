require "spec_helper"

describe SessionsController do
  render_views

  describe "#create" do


    context "invalid credentials"  do

      it "returns unauthorized for invalid credentials" do
        post :create, username: "tester", password: "tester"
        response.status.should == 401
      end

    end

    context "valid credentials" do
      let!(:user) { create :user, password: "mytester", username: "john" }

      it "returns a 200 status for valid credentials" do
        post :create, username: "john", password: "mytester"
        response.status.should == 200
      end

      it "returns a valid API key" do
        expect  {
          post :create, username: "john", password: "mytester"
        }.to change { UserKey.count }.by(1)

        body = JSON.parse(response.body)
        body['api_key'].should == UserKey.last.token
      end
    end
  end
end
