;(function(EcmaSh) {

  EcmaSh.History = Backbone.Collection.extend({
    initialize: function() {

      this.commands = new Backbone.Collection();

      this.on("add",this.addToCommands,this);
    },

    addToCommands: function(model) {
      if(model instanceof EcmaSh.CommandLine) {
        this.commands.add(model);
      }
    },

    addResult: function(model) {
      this.add(
        new EcmaSh.Result({ 
          result: model.get("result"), 
          type: model.type,
          as: model.get("as")
        })
      );
      this.trigger("done");
    },

    addError: function(model) {
      this.add(
        new EcmaSh.Error({ 
          message: model.get("error"), 
          type: model.type 
        }, { 
          command: model 
        })
      );
      this.trigger("done");
    },

    commandAt: function(idx) {
      console.log([this.commands.length, this.commands ]);
      return this.commands.at(this.commands.length + idx);
    }
  });

  
}(EcmaSh));
