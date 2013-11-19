(function(EcmaSh) {

  EcmaSh.ShellView = EcmaSh.BaseView.extend({
    template: "shell",

    events: {
      "click": "focusPrompt",
      "input .prompt": "handleChange",
      "drop": "handleDrop",
      "dragenter": "handleDrag",
      "dragover": "handleDrag",
    },

    initialize: function() {
      this.collection = this.model.history;

      if(this.model.user.get("api_key")) {
        this.commandPrompt = new EcmaSh.PromptView({ model: this.model, collection: this.collection });
      } else {
        this.commandPrompt = new EcmaSh.LoginView({ model: this.model.user});
      }
                                                    
      this.model.user.on("change:state",this.checkUser,this);
      this.model.user.on("change:api_key",this.loggedIn,this);

      this.collection.on("add",this.addToHistory,this);
      this.collection.on("done",this.showPrompt,this);
    },

    showPrompt: function() {
      if(this.commandPrompt.showPrompt) {
        this.commandPrompt.showPrompt();
      }
    },

    checkUser: function(user) {
      var state = user.get("state");
      if(state == 'guest' || state == 'register') {
        this.commandPrompt = new EcmaSh.RegisterView({ model: user });
        this.$el.append(this.commandPrompt.el);
        this.commandPrompt.render();
      }
    },

    loggedIn: function(user) {
      var api_key = user.get("api_key");
      if(api_key) {
        this.model.set("CWD","/home/" + user.get("username"));
        this.model.cookie();
        this.commandPrompt = new EcmaSh.PromptView({ model: this.model, collection: this.collection });
        this.$el.append(this.commandPrompt.el);
        this.commandPrompt.render();
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
      if(model instanceof EcmaSh.CommandLine) {
        this.addHistoryView(new EcmaSh.CommandView({ model: model }));
      } else if(model instanceof EcmaSh.Error) {
        this.addHistoryView(new EcmaSh.ErrorView({ model: model }));
      } else if(model instanceof EcmaSh.Result) {
        var ResultView = EcmaSh[ _.capitalize(model.get("as")) + "ResultView" ] ||
                         EcmaSh.ResultView;
        this.addHistoryView(new ResultView({ model: model }));
      }

      this.el.scrollTop = this.el.scrollHeight;
    },

    handleChange: function(e) {
      var $elem = $(e.currentTarget);
      var html = $elem.html();
      if(html.match(/</)) {
        $elem.text($elem.text());
      }
    },

    handleDrag: function(e) {
      e.preventDefault();
    },

    handleDrop: function(e) {
      e.stopPropagation();
      e.preventDefault();
      var files = e.originalEvent.dataTransfer.files;

      var command = this.model.runCommand("upload",files);
      var line = "Uploading " + files.length + " files to " + this.model.get("CWD");
      this.model.addToHistory(line,"",command);
    }
  });


}(EcmaSh));
