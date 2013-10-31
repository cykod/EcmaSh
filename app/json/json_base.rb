class JSONBase 

  def initialize(resource)
    @resource = resource
  end


  def build
    return nil unless @resource
    @builder = Jbuilder.new do |json|
      if @resource.is_a?(Array) || @resource.is_a?(ActiveRecord::Relation)
        json.array! @resource do |resource|
          yield json, resource
        end
      else
        yield json, @resource
      end
    end
  end

  def method_missing(meth,*args,&block)
    if meth.to_s =~ /(.+)_json$/
      self.send($1,*args,&block).target!
    elsif meth.to_s =~ /(.+)_hash$/
      self.send($1,*args,&block).attributes!
    else 
      raise NoMethodError, <<ERRORINFO
method: #{meth}
args: #{args.inspect}
on: #{self.to_yaml}
ERRORINFO
    end
  end

end
