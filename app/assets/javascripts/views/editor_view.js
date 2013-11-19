(function(EcmaSh) {

  EcmaSh.EditorView = EcmaSh.BaseView.extend({
    className: "editor",
    initialize: function() {
      console.log(this.model.toJSON());
    },

    render: function() {
      var self = this,
          file = this.model;
      CodeMirror.commands.save = function(obj,some){ 
        file.save({ content: obj.doc.getValue() });
      };

      CodeMirror.commands.wq = function(obj) {
        file.save({ content: obj.doc.getValue() });
        self.remove();
      };
      this.editor = CodeMirror(this.el, {
        value: this.model.get("content"),
        lineWrapping: true,
        lineNumbers: true,
        autoFocus: true,
        mode:  "javascript",
        keyMap: "vim"
      });
    }
  });


}(EcmaSh));
