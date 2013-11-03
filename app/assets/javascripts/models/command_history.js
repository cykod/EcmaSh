;(function(EcmaSh) {

  EcmaSh.CommandHistory = Backbone.Collection.extend({
    initialize: function() {

      this.on("ran",this.addResult,this);
      this.on("error",this.addError,this);
    },

    addResult: function(model) {
      this.add(
        new EcmaSh.Result({ 
          result: model.get("result"), 
          type: model.type 
        }, { 
          command: model 
        })
      );
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
    }
  });

  
}(EcmaSh));
