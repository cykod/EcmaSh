class FileNode < Node

  has_attached_file :file, :styles =>  { :small  => "160x120#" }

  before_validation :set_name_and_properties, on: :create

  has_one :file_node_content

  def has_content?; self.file_node_content.present?; end

  def content
    if self.file_node_content
      self.file_node_content.content
    end
  end

  def content_type
    self.has_content? ? self.file_node_content.content_type : self.file_content_type
  end

  protected

  def set_name_and_properties
    if file_file_name.present?
      set_base_properties

      if self.file_type == "image"
        set_image_properties
      elsif self.file_type == "text"
        set_text_properties
      end
    end
  end

  def set_base_properties
    self.name = self.file_file_name
    self.file_type = self.file_content_type.split("/")[0]
  end

  def set_image_properties
    geometry = Paperclip::Geometry.from_file(file.queued_for_write[:original].path)
    self.width = geometry.width
    self.height = geometry.height
  end

  def set_text_properties
    txt = File.open(file.queued_for_write[:original].path).read
    content = self.build_file_node_content(
      content: txt,
      content_type: self.file_content_type
    )
    file.clear
  end

end
