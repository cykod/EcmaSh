require 'spec_helper'

describe FileNode do
  

  context "image file" do 
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

  context "text file" do
    let(:text_file) { FileNode.create(file: fixture_file_upload("text/sample_file.txt", "text/plain")) }

    it "should have content" do
      text_file.should have_content
    end

    it "sets the content" do
      text_file.content.should == "This is a test of the emergency broadcast system.\n\nThis is only a test.\n"
    end

    it "sets the content content type" do
      text_file.content_type.should == "text/plain"
    end

  end
end

