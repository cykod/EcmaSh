class Node < ActiveRecord::Base

  belongs_to :parent, class_name: "Node"
  belongs_to :user

  before_save :set_full_path
  before_save :set_parent_ids

  scope :directories, -> { where("type = 'DirectoryNode'") }

  def directory?; false; end

  validates :name, format: { with:  /\A[a-zA-Z\-._0-9]+\z/ }, uniqueness: { scope:  :parent_id }

  PUBLIC = 1   # anyone can list directory
  PRIVATE = 2  # anyone can view files in directory
  SECRET = 3   # only user can read

  def self.fetch(fullpath)
    where(fullpath: fullpath).first
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
