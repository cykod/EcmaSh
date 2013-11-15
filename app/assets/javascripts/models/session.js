(function(EcmaSh) {

  EcmaSh.Session = Backbone.Model.extend({

    initialize: function(attributes) {

      if(!this.get("env")) {
        this.set("env",localStorage['ecma_env'] ? JSON.parse(localStorage['ecma_env']) : {});
      }

      if(!this.get("user")) {
        this.set("user",localStorage['ecma_user'] ? JSON.parse(localStorage['ecma_user']) : {});
      }
       
    },

    save: function(env,user) {
      localStorage["ecma_env"] = JSON.stringify(env.toJSON());
      localStorage["ecma_user"] = JSON.stringify(user.toJSON());
    }

  });

}(EcmaSh));


