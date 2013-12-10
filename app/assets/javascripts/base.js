

window.EcmaSh = window.EcmaSh || {};

EcmaSh.BaseView = Backbone.View.extend({
  tmpl: function(properties) {
    return HandlebarsTemplates[this.template](properties);
  },

  assign : function (view, selector) {
    view.setElement(this.$(selector)).render();
  },

  render: function() {
    this.$el.empty().html(this.tmpl(this.model ? this.model.toJSON() : {}));
    return this;
  },

  pressedKey: function(e,keyCode) {
    if(e.which == keyCode && !e.shiftKey) {
      e.preventDefault();
      return true;
    } else {
      return false;
    }
  },


  pressedEnter: function(e) { return this.pressedKey(e,13); },
  pressedTab: function(e) { return this.pressedKey(e,9); },
  pressedUp: function(e) { return this.pressedKey(e,38); },
  pressedDown: function(e) { return this.pressedKey(e,40); },

  focusPrompt: function() {
    var $prompt = this.$el.parents(".shell").find(".prompt");
    setTimeout(function() {
     $prompt.focus();
    },10);
  }


});


