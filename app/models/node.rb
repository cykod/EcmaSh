class Node < ActiveRecord::Base

  belongs_to :parent, class_name: "Node"
  belongs_to :user

  before_save :set_full_path
  before_save :set_parent_ids



  scope :directories, -> { where("type = 'DirectoryNode'") }

  def directory?; false; end


  PUBLIC = 1   # anyone can list directory
  PRIVATE = 2  # anyone can view files in directory
  SECRET = 3   # only user can read

  def self.fetch(fullpath)
    where(fullpath: fullpath).first
  end

  def self.fetch_directory(fullpath)
    DirectoryNode.where(fullpath: fullpath).first
  end

  def setup
    set_full_path
    set_parent_ids
    set_name_and_properties
    self
  end


  protected

  
  def set_full_path
    root = self.parent ? self.parent.fullpath : ""; 
    self.fullpath = "#{root}/#{self.name}"
  end

  def set_parent_ids
    if self.parent
      self.parent_ids = (self.parent.parent_ids||[]) + [ self.parent_id ]
    else
      self.parent_ids = []
    end
  end


end
