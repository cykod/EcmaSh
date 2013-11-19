(function(EcmaSh) {

  EcmaSh.PromptView = EcmaSh.BaseView.extend({
    template: "prompt",
    className: "line",

    events: {
      "keydown .prompt": "checkSubmit",
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

      if(this.pressedEnter(e)) { 
        this.runCommand();
      } else if(this.pressedTab(e)) {

      }

    },

    runCommand: function() {
      var self = this;
      var commandLine = this.$(".prompt").text().trim();

      this.$el.hide();
      this.model.runLine(this.promptLine(),commandLine);
    },

    showPrompt: function() {
      this.$el.show();
      this.render();
      this.focusPrompt();
    }
  });


}(EcmaSh)); 
