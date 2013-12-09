;(function(EcmaSh) {

  EcmaSh.commands = {};
  EcmaSh.aliases = { cat: "show", vi: "edit", more: "show", less: "show", exit: 'logout', move: 'mv', copy: 'cp' };

  EcmaSh.Command = Backbone.Model.extend({

    initialize: function(attributes,options) {
      this.type = this.type || options.type
      this.context = options.context;
      //
    },

    url: function() {
      return "/commands/" + this.type
    },

    run: function() {
      var self = this;
      var data = { argv: this.get("argv"), context: this.context.toJSON(), token: this.context.user.get("api_key")};

      this.save({}, {
        success: function() { 
          self.trigger("ran", self);
        },
        error: function(model,xhr) { 
          var error = xhr.responseJSON && xhr.responseJSON.error ? xhr.responseJSON.error : "Unknown Error";
          self.set("error",error);
        },
        data: $.param(data)
      });
      return this;
    },

    // deferred trigger to let
    // UI catch up
    done: function() {
      var self = this;
      setTimeout(function() {
        self.trigger("ran",self);
      },1);
    }
  });

  EcmaSh.Command.run = function(name,context,args,options) {
    var commandName = EcmaSh.aliases[name] || name;
    var commandClass = EcmaSh.commands[commandName] || EcmaSh.Command;
    args["as"] = name;
    var command = new commandClass(args,{ type: commandName, context: context });
    if(options && options.callback) {
      command.on("ran",options.callback);
      command.on("error",options.callback);
    }
    command.run();
    return command;
  }

  EcmaSh.CdCommand = EcmaSh.Command.extend({
    initialize: function(attributes,options) {
      EcmaSh.Command.prototype.initialize.call(this,attributes,options);
      this.on("ran",this.changeDirectory,this);
    },

    changeDirectory: function() {
      this.context.set("CWD",this.get("result").fullpath);
    }

  });

  EcmaSh.UploadCommand = EcmaSh.Command.extend({

    run: function() {
      var self = this;

      var formdata = new FormData();
      for(var i =0;i<this.get("argv").length;i++) {
        formdata.append("files[]",this.get("argv")[i]);
      }
      formdata.append("token",this.context.user.get("api_key"));

      this.save({}, {
        url: this.context.get("CWD"),
        data: formdata,  
        processData: false,  
        contentType: false,  
        success: function() { 
          self.trigger("ran", self);
        },
        error: function(model,xhr) { 
          var error = xhr.responseJSON && xhr.responseJSON.error ? xhr.responseJSON.error : "Unknown Error";
          self.set("error",error);
          if(callback) callback();
        }
      });
    }
  });


  EcmaSh.LogoutCommand = EcmaSh.Command.extend({
    initialize: function(attributes,options) {
      EcmaSh.Command.prototype.initialize.call(this,attributes,options);
    },

    run: function() {
      var self = this;
      this.context.user.destroy({ success: function() {
          self.context.trigger("logout");
        },
        data: $.param({ token: this.context.user.get("api_key") })
      });
    }

  });


  EcmaSh.SourceCommand = EcmaSh.Command.extend({
    initialize: function(attributes,options) {
      EcmaSh.Command.prototype.initialize.call(this,attributes,options);
    },


    run: function() {

      var url = EcmaSh.resolvePath(this.get("argv")[0],this.context.get("CWD")) + "?token=" + this.context.user.get("api_key");

      this.set("result", {  path: url });
      this.done();
    }

  });


  EcmaSh.commands['logout'] = EcmaSh.LogoutCommand;
  EcmaSh.commands['cd'] = EcmaSh.CdCommand;
  EcmaSh.commands['upload'] = EcmaSh.UploadCommand;
  EcmaSh.commands['source'] = EcmaSh.SourceCommand;

  
}(EcmaSh));
