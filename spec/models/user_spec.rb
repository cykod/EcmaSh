require "spec_helper"


describe User do


  describe ".login" do
    let!(:user) { create :user, username: 'tester', password: 'gogo'  }


    it "finds the user with a valid password" do
      User.login('tester','gogo').should == user
    end

    it "doesn't find the user with an invalid password" do
      User.login('tester','iglasdfa').should be_false
    end


  end
  

  describe "#generate_key" do

    let!(:user) { create :user }
  
    it "creates a new user key" do

      expect { user.generate_key }.to change { UserKey.count }.by(1)
    end

  end
  



end
