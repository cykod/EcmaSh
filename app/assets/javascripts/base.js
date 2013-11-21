

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


  pressedEnter: function(e) {

    if(e.which == 13 && !e.shiftKey) {
      e.preventDefault();
      return true;
    } else {
      return false;
    }
  },

  pressedTab: function(e) {
    if(e.which == 9 && !e.shiftKey) {
      e.preventDefault();
      return true;
    } else {
      return false;
    }
  },

  focusPrompt: function() {
    var $prompt = this.$el.parents(".shell").find(".prompt");
    setTimeout(function() {
     $prompt.focus();
    },10);
  }


});


