class ProcessStatic
  unloadable

  def initialize(app)
    @app = app
  end

  def call(env)
    host = env['SERVER_NAME']

    if Domain.base_domain?(host)
      return @app.call(env)
    else
      @directory = Domain.base_directory(host)
      if @directory
        @node = Node.fetch(@directory.fullpath + env['PATH_INFO'])
        if @node 
          return @node.has_content? ? send_node(@node) : send_redirect(@node)
        end
      end
    end

    not_found
  end

  def send_node(node)
    send_content(200,node.content, "Content-Type" => node.content_type, "Content-Disposition" => 'inline', "Name" => node.name, 'Access-Control-Allow-Origin' => "*")
  end

  def send_redirect(node)
    [301, { "Location" => node.file(:original) }, []]
  end

   def not_found
     send_content(404,"Page Not Found")
   end

   def send_content(status,content,headers={})
     length = content.size.to_s
     [status, {'Content-Type' => 'text/html', 'Content-Length' => length}.merge(headers), [content]]
   end
end
