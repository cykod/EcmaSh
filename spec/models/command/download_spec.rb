require "spec_helper"

describe Command::Download do


  let(:user) { create :user }
  let(:dir) { create :directory_node, user: user }

  def run_download_command(cwd, arg)
    Command.run(user,:download,{ "CWD" => cwd },[ arg ])
  end

  it "doesn't download files in a random directory" do
    result = run_download_command("/teste/rama", "http://www.google.com/rails.png")
    result.is_a?(CantWriteError).should be_true
  end

  it "does download files in a directory I own" do
    fixture = fixture_file_upload("images/rails.png", "image/png")
    FakeWeb.register_uri(:get, "http://www.google.com/rails.png", body: fixture.read)

    expect { 
      result = run_download_command(dir.fullpath, "http://www.google.com/rails.png")
    }.to change { FileNode.count }.by(1)

    FileNode.last.name.should == "rails.png"
  end
  
  
end
