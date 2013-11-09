(function(EcmaSh) {

  EcmaSh.ShellView = EcmaSh.BaseView.extend({
    template: "shell",

    events: {
      "click": "focusPrompt"
    },

    initialize: function() {
    //  this.commandPrompt = new EcmaSh.PromptView({ model: this.model, 
    //                                               collection: this.collection });

      this.commandPrompt = new EcmaSh.LoginView({ model: this.model.user});
                                                    
      this.model.user.on("change:state",this.checkUser,this);

      this.collection.on("add",this.addToHistory,this);
    },

    checkUser: function(model) {
      var state = model.get("state");
      if(state == 'guest' || state == 'register') {
        this.commandPrompt = new EcmaSh.RegisterView({ model: model });
        this.$el.append(this.commandPrompt.render().el);
      }
    },

    focusPrompt: function(e) {
      // only if the click is on the empty shell
      if(!e || e.target == $(".shell")[0]) {
        this.$(".prompt").focus();
      }
    },

    render: function() {
      this.$el.empty();
      this.$el.append(this.commandPrompt.render().el);
      this.focusPrompt();
    },

    addHistoryView: function(view) {
      this.commandPrompt.$el.before(view.render().el);
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
