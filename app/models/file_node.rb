class FileNode < Node

  has_attached_file :file

  before_validation :set_name_and_properties, on: :create

  has_one :file_node_content

  validates :name, format: { with:  /\A[^\n\t\/]+\z/ }, uniqueness: { scope:  :parent_id }

  def has_content?; self.file_node_content.present?; end

  def setup
    super
    self.build_file_node_content(content: "\n",content_type: self.file_content_type) if self.file_type == "text"
    self
  end

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
    self.content_type.present? ? self.content_type.split("/")[1] : "plain"
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

  def copy(destination,file_name = nil)
    file_name = self.name if file_name.blank?
    # handle content case
    
    if self.has_content? 
      node = self.dup
      node.attributes = { file_node_content: self.file_node_content.dup,
                          name: file_name,
                          parent: destination }
    else
      dest = self.file.url  =~ /^https?\:\/\// ? URI.parse(self.file.url) : File.open(self.file.path)
      node = FileNode.new(parent: destination, file: dest, user: self.user)
      node.file.instance_write(:file_name,file_name)
    end
    node.save && node
  end

  @@type_overrides = {
    "md" => "text/x-markdown"
  }

  def self.type_for_name(name)
    extension = name.split(".")[-1].to_s.downcase
    @@type_overrides[extension] || 
      Mime::Type.lookup_by_extension(extension).to_s
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
    elsif name.present?
      self.file_content_type = FileNode.type_for_name(self.name)
      set_base_properties
    end
  end

  def set_base_properties
    self.name = self.file_file_name if self.file_file_name.present?

    if self.file_content_type == "application/json"
      self.file_type = "text"
    else
      self.file_type = self.file_content_type.split("/")[0]
    end
  end

  def set_image_properties
    geometry = Paperclip::Geometry.from_file(file.queued_for_write[:original].path)
    self.width = geometry.width
    self.height = geometry.height
  end

  def set_text_properties
    txt = File.open(file.queued_for_write[:original].path).read
    self.file_content_type = FileNode.type_for_name(self.name)
    content = self.build_file_node_content(
      content: txt,
      content_type: self.file_content_type
    )
    file.clear
  end

end
