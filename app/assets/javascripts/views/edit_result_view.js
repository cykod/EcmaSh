(function(EcmaSh) {

 EcmaSh.EditResultView = EcmaSh.BaseView.extend({
    initialize: function(options) {
      this.shell = options.shell;
    },

    render: function() {
      var file = new EcmaSh.File(this.model.get("result"));
      file.set({ as: this.model.get("as"), token: this.shell.user.get("api_key") });
      this.editorView = new EcmaSh.EditorView({ model: file });
      this.$el.parents(".shell").append(this.editorView.el);
      this.editorView.render();
      return this;
    }
  });


}(EcmaSh));
