require "spec_helper"

describe Command::Get do

  let(:user) { create :user }

  def run_get_command( arg)
    Command.run(user,:get,{  },[ arg ])
  end

  it "returns websites in the content attribute" do
    FakeWeb.register_uri(:get, "http://www.google.com/", body: "<h1>Yay!</h1>", content_type: "text/html")

    result = run_get_command("http://www.google.com")
    result['content'].should == "<h1>Yay!</h1>"
  end

  it "returns JSON in JSON format with the correct content type" do
    FakeWeb.register_uri(:get, "http://www.somewhere.com/tester.json", body: '{ "a": "b" }', content_type: "application/json")

    result = run_get_command("http://www.somewhere.com/tester.json")
    result["a"].should == "b"
  end
  

  it "returns JSON in JSON format without a correct content type" do
    FakeWeb.register_uri(:get, "http://www.somewhere.com/tester.json", body: '{ "a": "b" }', content_type: "application/octet-stream")

    result = run_get_command("http://www.somewhere.com/tester.json")
    result["a"].should == "b"
  end

  it "returns XML in JSON format with the correct content type" do
    FakeWeb.register_uri(:get, "http://www.somewhere.com/tester.xml", body: '<abc>b</abc>', content_type: "application/xml ")

    result = run_get_command("http://www.somewhere.com/tester.xml")
    result["abc"].should == "b"
  end
  
end
