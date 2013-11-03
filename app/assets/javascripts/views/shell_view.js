(function(EcmaSh) {

  EcmaSh.ShellView = EcmaSh.BaseView.extend({
    template: "shell",
    initialize: function() {
      this.commandPrompt = new EcmaSh.PromptView({ model: this.model, 
                                                   collection: this.collection });
    },

    render: function() {
      EcmaSh.BaseView.prototype.render.apply(this);
      this.assign(this.commandPrompt, ".prompt");

    }
  });


}(EcmaSh));
