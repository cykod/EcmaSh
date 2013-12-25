require "spec_helper"

describe ProcessStatic do
  def env_for url, opts={}
    Rack::MockRequest.env_for(url, opts)
  end

  let(:app) { ->(env) { [200, env, "app"] } }
  let(:middleware) { ProcessStatic.new(app) }


  let(:directory) { create :directory_node, name: "tester", parent: DirectoryNode.home_node }

  let(:image_file) { FileNode.create(file: fixture_file_upload("images/rails.png","image/png"), parent: directory) }
  let(:text_file) { FileNode.create(file: fixture_file_upload("text/sample_file.txt", "text/plain"), parent: directory ) }

  let(:other_file) { FileNode.create(file: fixture_file_upload("text/sample_file.txt", "text/plain"), parent: DirectoryNode.home_node ) }


  context "no domain" do
    it "returns a 404 for invalid files" do
      status, env = middleware.call env_for("http://tester.com/ok")
      status.should == 404
    end

    it "returns a 404 for any file" do
      status, env = middleware.call env_for("http://tester.com/ok")
      status.should == 404
    end
  end

  context "valid domain" do
    let!(:domain) { create :domain, directory_node: directory }

    it "returns the contents of a text file" do
      status, env, content =  middleware.call env_for("http://#{domain.name}/#{text_file.name}")
      content[0].should == text_file.content
    end

    it "redirects tot he image file" do
      status, env, content =  middleware.call env_for("http://#{domain.name}/#{image_file.name}")
      env['Location'].should == image_file.file.url(:original)
    end

    it "404's for a file in a different directory" do
      status, env, content =  middleware.call env_for("http://#{domain.name}/#{other_file.name}")
      status.should == 404
    end

  end


end
