(function(EcmaSh) {

  EcmaSh.ShellView = EcmaSh.BaseView.extend({
    template: "shell",

    events: {
      "click": "focusPrompt"
    },

    initialize: function() {
      this.commandPrompt = new EcmaSh.PromptView({ model: this.model, 
                                                   collection: this.collection });

      this.collection.on("add",this.addToHistory,this);
    },

    focusPrompt: function(e) {
      // only if the click is on the empty shell
      if(!e || e.target == $(".shell")[0]) {
        this.$(".prompt-command").focus();
      }
    },

    render: function() {
      EcmaSh.BaseView.prototype.render.apply(this);
      this.assign(this.commandPrompt, ".prompt");

      this.focusPrompt();
    },

    addHistoryView: function(view) {
      this.$(".history").append(view.render().el);
    },

    addToHistory: function(model) {
      if(model instanceof EcmaSh.Command) {
        this.addHistoryView(new EcmaSh.CommandView({ model: model }));
      } else if(model instanceof EcmaSh.Error) {
        this.addHistoryView(new EcmaSh.ErrorView({ model: model }));
      } else if(model instanceof EcmaSh.Result) {
        this.addHistoryView(new EcmaSh.ResultView({ model: model }));
      }

      this.el.scrollTop = this.el.scrollHeight;
    }
  });


}(EcmaSh));
