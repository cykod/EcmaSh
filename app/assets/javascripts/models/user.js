(function(EcmaSh) {

  EcmaSh.User= Backbone.Model.extend({


    url: function() {
      if(this.get("state") && !this.get("api_key")) {
        if(this.get("username") == "guest") {
          return "/guests"
        } else {
          return "/registrations"
        }
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
    },

    registerGuest: function() {
      this.set("username","guest")
      this.set("guest",true)
      this.save();
    }
  });


}(EcmaSh));
