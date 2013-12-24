require "spec_helper"

describe Command::Get do

  let(:user) { create :user }

  def run_get_command(cwd, arg)
    Command.run(user,:get,{  },[ arg ])
  end

  it "returns websites in the content attribute"

  it "returns JSON in JSON format"
  
  
end
