(function(EcmaSh) {

  EcmaSh.PromptView = EcmaSh.BaseView.extend({
    template: "prompt",
    className: "line",

    events: {
      "keydown .prompt": "checkSubmit",
      "keyup .prompt": "updatePrompt",
      "change .prompt": "updatePrompt",
      "click": "focusPrompt"
    },


    initialize: function() {
      this.prompt = new EcmaSh.Prompt({}, { shell: this.model });

      this.prompt.on("change:prompt",this.setPromptText,this);
      this.prompt.on("reposition",this.setPosition,this);
    },

    render: function() {
      var output = this.tmpl({ promptLine: this.prompt.promptLine() });
      this.$el.empty().html(output);
      this.$prompt = this.$(".prompt");
      this.focusPrompt();
      return this;
    },

    setPromptText: function(model) {
      this.$prompt.text(this.prompt.get("prompt"));
    },

    updatePrompt: function() {
      this.prompt.set("prompt",this.$prompt.text(), { silent: true }); 
    },

    focusPrompt: function() {
      this.$prompt.focus();
    },

    checkSubmit: function(e) {
      this.updatePrompt();
      if(this.pressedTab(e)) {
        this.prompt.runAutocomplete(this.getPosition());
        e.preventDefault();
      } else {
        this.prompt.cancelAutocomplete();
        if(this.pressedEnter(e)) { 
          this.$el.hide();
          this.prompt.runCommand(); 
        }
      }
    },

    showPrompt: function() {
      this.$el.show();
      this.render();
      this.focusPrompt();
    },

    // http://stackoverflow.com/questions/4811822/get-a-ranges-start-and-end-offsets-relative-to-its-parent-container/4812022#4812022
    getPosition: function() {
      var caretOffset = 0;
      var element = this.$prompt[0];
      var doc = element.ownerDocument || element.document;
      var win = doc.defaultView || doc.parentWindow;
      var sel;
      if (typeof win.getSelection != "undefined") {
        var range = win.getSelection().getRangeAt(0);
        var preCaretRange = range.cloneRange();
        preCaretRange.selectNodeContents(element);
        preCaretRange.setEnd(range.endContainer, range.endOffset);
        caretOffset = preCaretRange.toString().length;
      } else if ( (sel = doc.selection) && sel.type != "Control") {
        var textRange = sel.createRange();
        var preCaretTextRange = doc.body.createTextRange();
        preCaretTextRange.moveToElementText(element);
        preCaretTextRange.setEndPoint("EndToEnd", textRange);
        caretOffset = preCaretTextRange.text.length;
      }
      return caretOffset;
    },

    setPosition: function(position) {
      var sel;
      this.$prompt.focus();
      if (document.selection) {
        sel = document.selection.createRange();
        sel.moveStart('character', position);
        sel.select();
      }
      else {
        sel = window.getSelection();
        sel.collapse(this.$prompt[0].firstChild, position);
      }
    }
  });


}(EcmaSh)); 
