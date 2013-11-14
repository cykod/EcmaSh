(function(EcmaSh) {

  EcmaSh.Shell = Backbone.Model.extend({
    initialize: function(attributes,options) {

      var ecmaEnv = localStorage['ecma_env'] ? JSON.parse(localStorage['ecma_env']) : {}
      var ecmaUser = localStorage['ecma_user'] ? JSON.parse(localStorage['ecma_user']) : {}

      this.set(ecmaEnv);

      this.user = new EcmaSh.User(ecmaUser);

      this.commandHistory = new EcmaSh.CommandHistory();

      this.shellView = new EcmaSh.ShellView({ el: options.el,
                                              model: this, 
                                              collection: this.commandHistory }).render();

    },

    cookie: function() {
      localStorage["ecma_env"] = JSON.stringify(this.toJSON());
      localStorage["ecma_user"] = JSON.stringify(this.user.toJSON());

    }
  });


}(EcmaSh));
