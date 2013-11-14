(function(EcmaSh) {

  EcmaSh.PromptView = EcmaSh.BaseView.extend({
    template: "prompt",
    className: "line",

    events: {
      "keyup .prompt": "checkSubmit",
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
      var output = this.tmpl({ promptLine: this.promptLine() });
      this.$el.empty().html(output);
      this.focusPrompt();
      return this;
    },

    promptLine: function() {
      var props = this.props();
      var line =  Handlebars.compile(props.PROMPT)(props);
      return line;
    },

    focusPrompt: function() {
      this.$(".prompt").focus();
    },

    checkSubmit: function(e) {
      var self = this;

      if(e.which == 13 && !e.shiftKey) {
        e.preventDefault();

        var command = this.$(".prompt").text().trim();
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
