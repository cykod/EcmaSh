;(function(EcmaSh) {

  EcmaSh.commands = {};

  EcmaSh.Command = Backbone.Model.extend({

    initialize: function(attributes,options) {
      this.type = this.type || options.type
    },

    url: function() {
      return "/commands/" + this.type
    },

    run: function() {
      var self = this;

      this.save({}, {
        success: function() { 
          self.trigger("ran", self.get("result"));
        },
        error: function(model,xhr) { 
          var result = $.parseJSON(xhr.response)
          self.set("error",result.error)
          self.trigger("error",result.error);
        }
      });
    }
  });

  EcmaSh.Command.run = function(name, args) {
    var commandClass = EcmaSh.commands[name] || EcmaSh.Command;
    return new commandClass(args,{ type: name });
  }

  
}(EcmaSh));
