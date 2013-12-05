class FileNode < Node

  has_attached_file :file

  before_validation :set_name_and_properties, on: :create

  has_one :file_node_content

  validates :name, format: { with:  /\A[^\n\t\/]+\z/ }, uniqueness: { scope:  :parent_id }

  def has_content?; self.file_node_content.present?; end

  def content
    if self.file_node_content
      self.file_node_content.content
    end
  end
  
  def content=(val)
    if self.file_node_content 
      self.file_node_content.update_attributes(content: val)
    end
  end

  def content_type
    self.has_content? ? self.file_node_content.content_type : self.file_content_type
  end

  def content_subtype
    self.content_type.split("/")[1]
  end

  def image?
    self.file_type == "image"
  end

  def text?
    self.file_type == "text"
  end

  def audio?
    self.file_type == "audio"
  end

  def copy(destination,file_name)
    # handle content case
    dest = URI.parse(self.file.url)
    node = FileNode.new(parent: destination, file: dest)
    node.file.instance_write(:file_name,file_name)
    node.save && node
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
