(function(EcmaSh) {

  EcmaSh.PromptView = EcmaSh.BaseView.extend({
    template: "prompt",

    events: {
      "keyup .prompt-command": "checkSubmit",
    },


    defaults: {
      PROMPT: "{{CWD}} $"
    },

    initialize: function() {
    },

    render: function() {
      var props = _.defaults(this.model.toJSON(),this.defaults);

      var promptLine = { line: Handlebars.compile(props.PROMPT)(props) }

      this.$el.empty().html(this.tmpl(promptLine));
    },

    checkSubmit: function(e) {
      if(e.which == 13 && !e.shiftKey) {
        e.preventDefault();

        var argv = this.$(".prompt-command").val().split(" ");
        var name = argv.shift();

        var command = EcmaSh.Command.run(name, { context: this.model.toJSON(), argv: argv });

        this.collection.add(command);
        command.save();
        
        this.render();
      }

    }
  });


}(EcmaSh));
