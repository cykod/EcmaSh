(function(EcmaSh) {

  EcmaSh.User= Backbone.Model.extend({


    url: function() {
      if(this.get("state")) {
       return "/registrations"
      } else {
       return "/sessions"
      }

    },

    checkUsername: function(username,callback) {
      var self = this;
      $.get("/registrations/" + encodeURIComponent(username),function(data) {
        if(!data["error"]) { self.set("username",username); }
        self.set({ "error": data["error"] });
        callback(self);
      });
    }
  });


}(EcmaSh));
