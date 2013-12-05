class Command::Mv < Command::Cp
  def run
    source_node = super
    source_node.destroy if source_node
  end
end
