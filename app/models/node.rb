class Node < ActiveRecord::Base

  belongs_to :parent, class_name: "Node"

  before_save :set_full_path

  def directory?; false; end

  validates :name, format: { with:  /\A[a-zA-Z\-._0-9]+\z/ }

  protected

  
  def set_full_path
    root = self.parent ? self.parent.fullpath : ""; 
    self.fullpath = "#{root}/#{self.name}"
  end


end
