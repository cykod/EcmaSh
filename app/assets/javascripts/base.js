

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
  }
});


