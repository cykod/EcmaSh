class FileNode < Node

  has_attached_file :file, :styles =>  { :small  => "160x120#" }

  before_validation :set_name_and_properties, on: :create


  protected

  def set_name_and_properties
    self.name = self.file_file_name
    self.file_type = self.file_content_type.split("/")[0]

    if self.file_type == "image"
      geometry = Paperclip::Geometry.from_file(file.queued_for_write[:original].path)
      self.width = geometry.width
      self.height = geometry.height
    end
  end

end
