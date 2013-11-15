;(function(EcmaSh) {

  EcmaSh.CommandLine = Backbone.Model.extend({

    initialize: function(attributes,options) {
      this.command = options.command;

      var self = this;
      this.command.on("error",function() { self.trigger("error",self); });
      this.command.on("ran",function() { self.trigger("ran",self); });

    }

  });


}(EcmaSh));
