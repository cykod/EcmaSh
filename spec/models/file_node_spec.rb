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

    describe "#copy"  do
      let(:directory) { create :directory_node, name: "tester" }
      
      it "copys the file over" do
        image_file

        expect {
          result = image_file.copy(directory,"something.png")
          result.file_file_name.should == "something.png"
          result.file.url.should include("something.png")
          result.parent.should == directory
        }.to change { FileNode.count }.by(1)

      end

    end
  end

  context "file upload application/octet-stream" do
    let(:json_file) { FileNode.create(file: fixture_file_upload("text/sample.json", "application/octet-stream")) }

    it "should have content" do
      json_file.should have_content
    end

    it "should be a text file" do
      json_file.should be_text
    end

    it "sets the content content type" do
      json_file.content_type.should == "application/json"
    end
  end

  context "json file" do
    let(:json_file) { FileNode.create(file: fixture_file_upload("text/sample.json", "application/json")) }

    it "should have content" do
      json_file.should have_content
    end

    it "should be a text file" do
      json_file.should be_text
    end

    it "sets the content content type" do
      json_file.content_type.should == "application/json"
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

    describe "#content=" do

      it "update the content model" do
        text_file.content = "This is the content"
        text_file.save
        text_file.reload.content.should == "This is the content"
      end
    end


    describe "#copy" do
      let(:directory) { create :directory_node, name: "tester" }

      it "copys the file and contents over" do
        text_file

        expect {
          result = text_file.copy(directory,"somethinger.txt")
          result.name.should == "somethinger.txt"
          text_file.content.should == "This is a test of the emergency broadcast system.\n\nThis is only a test.\n"
          result.parent.should == directory
        }.to change { FileNode.count }.by(1)

      end

    end
  end

end

