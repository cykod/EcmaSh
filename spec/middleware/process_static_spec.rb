require "spec_helper"

describe ProcessStatic do
  def env_for url, opts={}
    Rack::MockRequest.env_for(url, opts)
  end

  let(:app) { ->(env) { [200, env, "app"] } }
  let(:middleware) { ProcessStatic.new(app) }


  it "returns a 404 for invalid files" do
    status, env = middleware.call env_for("http://tester.com/ok")
    status.should == 404
  end

end
