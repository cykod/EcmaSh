(function(EcmaSh) {

  EcmaSh.PromptView = EcmaSh.BaseView.extend({
    template: "prompt",

    events: {
      "keyup .prompt-command": "checkSubmit",
      "click": "focusPrompt"
    },


    defaults: {
      PROMPT: "{{CWD}} $ "
    },

    initialize: function() {
    },

    props: function() {
      return _.defaults(this.model.toJSON(),this.defaults);
    },

    render: function() {
      this.$el.empty().html(this.tmpl({ line: this.promptLine() }));
    },

    promptLine: function() {
      var props = this.props();
      return  Handlebars.compile(props.PROMPT)(props);
    },

    focusPrompt: function() {
      this.$(".prompt-command").focus();
    },

    checkSubmit: function(e) {
      var self = this;

      if(e.which == 13 && !e.shiftKey) {
        e.preventDefault();

        var command = this.$(".prompt-command").val().trim();
        var argv = command.split(" ");
        var name = argv.shift();

        var command = EcmaSh.Command.run(name, this.model, { 
          promptLine: this.promptLine(),
          command: command,
          argv: argv, 
        });

        this.$el.hide();

        this.collection.add(command);

        command.run(function() {
          self.$el.show();
          self.render();
          self.focusPrompt();
        });
        
      }

    }
  });


}(EcmaSh));
