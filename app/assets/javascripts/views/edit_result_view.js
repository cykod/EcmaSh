(function(EcmaSh) {

 EcmaSh.EditResultView = EcmaSh.BaseView.extend({
    initialize: function() {
    },

    render: function() {
      var file = new EcmaSh.File(this.model.get("result"));
      file.set({ as: this.model.get("as") });
      this.editorView = new EcmaSh.EditorView({ model: file });
      this.$el.parents(".shell").append(this.editorView.el);
      this.editorView.render();
      return this;
    }
  });


}(EcmaSh));
