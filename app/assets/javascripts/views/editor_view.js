(function(EcmaSh) {

  EcmaSh.EditorView = EcmaSh.BaseView.extend({
    className: "editor",
    initialize: function() {
      //console.log(this.model.toJSON());
    },

    render: function() {
      var self = this,
          file = this.model,
          editor = file.get("as"),
          keyMap = null;

      CodeMirror.Vim.defineEx("quit","q",function() {
        self.focusPrompt();
        self.remove();
      });

      CodeMirror.commands.save = function(obj){ 
        file.save({ content: obj.doc.getValue() });
      };

      CodeMirror.Vim.defineEx("wquit","wq",function(obj) {
        file.save({ content: obj.doc.getValue() });
        self.focusPrompt();
        self.remove();
      });

      var options = {
        value: this.model.get("content"),
        lineWrapping: true,
        lineNumbers: true,
        autoFocus: true,
        mode:  this.model.get("file_subtype")
      }

      if(editor == "vi" || editor == "vim") {
        options.keyMap = "vim"
      }

      this.editor = CodeMirror(this.el, options );

      setTimeout(function() {
        self.editor.focus();
      },10);
    }
  });


}(EcmaSh));
