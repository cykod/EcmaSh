;(function(EcmaSh) {

  EcmaSh.History = Backbone.Collection.extend({
    initialize: function() {
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
    }
  });

  
}(EcmaSh));
