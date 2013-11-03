;(function(EcmaSh) {

  EcmaSh.commands = {};

  EcmaSh.Command = Backbone.Model.extend({

    initialize: function(attributes,options) {
      this.type = this.type || options.type
    },

    url: function() {
      return "/commands/" + this.type
    },

    run: function(callback) {
      var self = this;
      var data = _.pick(this.attributes,'argv','context');

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

  EcmaSh.Command.run = function(name, args) {
    var commandClass = EcmaSh.commands[name] || EcmaSh.Command;
    return new commandClass(args,{ type: name });
  }

  
}(EcmaSh));
