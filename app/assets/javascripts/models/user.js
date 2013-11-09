(function(EcmaSh) {

  EcmaSh.User= Backbone.Model.extend({


    url: function() {
      if(this.get("state")) {
       return "/registrations"
      } else {
       return "/sessions"
      }

    }
  });


}(EcmaSh));
