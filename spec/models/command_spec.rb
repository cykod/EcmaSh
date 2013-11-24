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
  
  describe "#resolve_directory_and_file" do

    let(:no_context_cmd) { Command.new(context: {}) }
    let(:base_context_cmd) { Command.new(context: { "CWD" =>  "/home/tester" }) }

    it "returns a directory and file separately" do
      dir, file = no_context_cmd.resolve_directory_and_file("/tester/rama")
      dir.should == '/tester'
      file.should == 'rama'
    end

    it "handles relative paths" do
      dir, file = no_context_cmd.resolve_directory_and_file("/tester/../something/rama")
      dir.should == '/something'
      file.should == 'rama'
    end

    it "handles relative paths" do
      dir, file = no_context_cmd.resolve_directory_and_file("/tester/../something/rama")
      dir.should == '/something'
      file.should == 'rama'
    end

    it "handles relative paths with context" do
      dir, file = base_context_cmd.resolve_directory_and_file("../something/here-is-a-file.txt")
      dir.should == '/home/something'
      file.should == 'here-is-a-file.txt'
    end
  end

end
