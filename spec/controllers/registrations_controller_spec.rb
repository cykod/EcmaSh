require "spec_helper"


describe RegistrationsController do
  render_views

  let(:json_body) { JSON.parse(response.body) }

  describe "#show" do
    
    it "returns no error message if the username is ok" do
      get :show, id: "franker"
      json_body["error"].should be_nil
    end

  end
    

end
