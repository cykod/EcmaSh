require "spec_helper"

describe SessionsController do
  render_views

  let(:json_body) { JSON.parse(response.body) }

  describe "#create" do


    context "invalid credentials"  do

      it "returns unauthorized for invalid credentials" do
        post :create, username: "tester", password: "tester"
        response.status.should == 401
      end

      it "returns an error message" do
        post :create, username: "tester", password: "tester"
        json_body["error"].should_not be_nil
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

        json_body["api_key"].should == UserKey.last.token
      end
    end
  end

  describe "#destroy" do

    let!(:user) { create :user }

    context "invalid credentials" do

      it "does nothing" do
        delete :destroy, token: "fdasfa"
        response.status.should == 200
      end
    end

    context "valid credentials" do

      it "destroys the key" do
        token = user.generate_token
        expect { 
          delete :destroy, token: token
        }.to change { UserKey.count }.by(-1)
      end
    end

  end
end
