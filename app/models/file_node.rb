class FileNode < Node

  has_attached_file :file, :styles =>  { :small  => "160x120#" }

end
