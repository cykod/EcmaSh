require "spec_helper"

describe Command do

  let(:user) { create :user }

  describe ".run" do

    context "invalid command name" do

      it "returns an exception" do
        output = Command.run(user, :my_random_command, {})
        output.is_a?(InvalidCommandError).should be_true
      end
    end

  end

  describe "#resolve_path" do

    let(:no_context_cmd) { Command.new(context: {}) }
    let(:base_context_cmd) { Command.new(context: { "CWD" =>  "/home/tester" }) }

    it "resolves absolute paths without a CWD" do
      no_context_cmd.resolve_path("/svender").should == "/svender"
    end

    it "resolves relative paths without a CWD" do
      no_context_cmd.resolve_path("svender").should == "/svender"
    end

    it "resolves absolute paths with a CWD" do
      base_context_cmd.resolve_path("/svender").should == "/svender"
    end

    it "resolves relative paths with a CWD" do
      base_context_cmd.resolve_path("svender").should == "/home/tester/svender"
    end

    it "resolves relative paths with .. with a CWD" do
      base_context_cmd.resolve_path("../svender").should == "/home/svender"
    end

    it "resolves relative paths with . with a CWD" do
      base_context_cmd.resolve_path("./svender").should == "/home/tester/svender"
    end
  end

end
