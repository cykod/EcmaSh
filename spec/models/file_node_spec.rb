require 'spec_helper'

describe FileNode do
  
  let(:image_file) { FileNode.create(file: fixture_file_upload("images/rails.png","image/png")) }
  context "#name" do


    it "auto sets the name from the file" do
      image_file.name.should == "rails.png"
    end

  end

  context "#file_type" do
    it "sets the file_type" do
      image_file.file_type.should == "image"
    end
  end

  context "#width and #height" do
    it "sets the dimensions" do
      image_file.width.should == 50
      image_file.height.should == 64
    end

  end

end

