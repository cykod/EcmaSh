;(function(EcmaSh) {

  EcmaSh.commands = {};

  EcmaSh.Command = Backbone.Model.extend({

    initialize: function(attributes,options) {
      this.type = this.type || options.type
      this.context = options.context;
    },

    url: function() {
      return "/commands/" + this.type
    },

    run: function(callback) {
      var self = this;
      var data = { argv: this.get("argv"), context: this.context.toJSON(), token: this.context.user.get("api_key")};

      this.save({}, {
        success: function() { 
          self.trigger("ran", self);
          if(callback) callback();
        },
        error: function(model,xhr) { 
          var error = xhr.responseJSON && xhr.responseJSON.error ? xhr.responseJSON.error : "Unknown Error";
          self.set("error",error);
          if(callback) callback();
        },
        data: $.param(data)
      });
    }

  });

  EcmaSh.Command.run = function(name,context,args) {
    var commandClass = EcmaSh.commands[name] || EcmaSh.Command;
    return new commandClass(args,{ type: name, context: context });
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
    initialize: function(attributes,options) {
      EcmaSh.Command.prototype.initialize.call(this,attributes,options);
    },

    run: function(callback) {
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
          if(callback) callback();
        },
        error: function(model,xhr) { 
          var error = xhr.responseJSON && xhr.responseJSON.error ? xhr.responseJSON.error : "Unknown Error";
          self.set("error",error);
          if(callback) callback();
        }
      });
    }
  });

  EcmaSh.commands['cd'] = EcmaSh.CdCommand;
  EcmaSh.commands['upload'] = EcmaSh.UploadCommand;

  
}(EcmaSh));
