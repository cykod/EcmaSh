(function(EcmaSh) {

  EcmaSh.File = Backbone.Model.extend({
    initialize: function(attributes) {

    },

    url: function() {
      return this.get("fullpath");
    }
  });
}(EcmaSh));
