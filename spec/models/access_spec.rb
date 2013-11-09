require "spec_helper"

describe Access do

  let(:user) { create :user }
  let(:user2) { create :user }
  
  let(:access) { user.access }

  let(:own_directory_node) { create :directory_node, user: user }
  let(:own_file_node)  { create :file_node, user: user, parent: own_directory_node }

  let(:public_directory_node) { create :directory_node, user: user2, lock_level: Node::PUBLIC }
  let(:public_file_node)  { create :file_node, user: user2, parent: public_directory_node }

  let(:private_directory_node) { create :directory_node, user: user2, lock_level: Node::PRIVATE }
  let(:private_file_node)  { create :file_node, user: user2, parent: private_directory_node }

  let(:secret_directory_node) { create :directory_node, user: user2, lock_level: Node::SECRET }
  let(:secret_file_node)  { create :file_node, user: user2, parent: secret_directory_node }

  describe "#read?" do

    it "should give a user read access to a node they own" do
      user.access.read?(own_file_node).should be_true
    end

    it "should give read access to a directory they own" do
      user.access.read?(own_directory_node).should be_true
    end

    it "should give access to someone else's public node" do
      user.access.read?(public_file_node).should be_true
    end

    it "should give acess to someone else's private node" do
      user.access.read?(private_file_node).should be_true
    end

    it "shouldn't give access to someone else's secret node directory" do
      user.access.read?(secret_file_node).should be_false
    end

  end

  describe "#write?" do

    it "should give user write access to it's own node" do
      user.access.write?(own_file_node).should be_true
    end

    it "should give user write access to it's own directory" do
      user.access.write?(own_directory_node).should be_true
    end

    it "shouldn't give access to someone elses public directory" do
      user.access.write?(public_directory_node).should be_false
    end

    it "shouldn't give access to someone elses private directory" do
      user.access.write?(private_directory_node).should be_false
    end

    it "shouldn't give access to someone elses secret directory" do
      user.access.write?(secret_directory_node).should be_false
    end
  end


  describe "#list?" do

    it "should give user list access to it's own directory" do
      user.access.list?(own_directory_node).should be_true
    end

    it "shouldn't give list access to someone elses public directory" do
      user.access.list?(public_directory_node).should be_true
    end

    it "shouldn't give list access to someone elses private directory" do
      user.access.list?(private_directory_node).should be_false
    end

    it "shouldn't give list access to someone elses secret directory" do
      user.access.list?(secret_directory_node).should be_false
    end
  end


  

end
