(function(EcmaSh) {

  EcmaSh.Shell = Backbone.Model.extend({
    initialize: function(attributes,options) {

      this.commandHistory = new EcmaSh.CommandHistory();

      this.shellView = new EcmaSh.ShellView({ el: options.el,
                                              model: this,
                                              collection: this.commandHistory }).render();

    }
  });


}(EcmaSh));
