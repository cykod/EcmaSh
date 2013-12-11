(function(EcmaSh) {

 EcmaSh.SourceResultView = EcmaSh.BaseView.extend({
   template: "result-source",
    initialize: function(options) {
      this.shell = options.shell;
    },

    render: function() {
      var shell = this.shell;

      var errorFunc = function(msg, url, line) { 
        shell.history.add(
          new EcmaSh.Error({ message: "Line " + line + ": " + msg })
          )
        return false;
      };

      window.onerror = errorFunc;

      var s = document.createElement('script');
      s.type = 'text/javascript';
      s.src = this.model.get("result").path;

      this.$el.empty().append(s);

      window.onerror = null;

    },


  });


}(EcmaSh));
