(function(EcmaSh) {

 EcmaSh.RunResultView = EcmaSh.BaseView.extend({
   template: "result-run",
    initialize: function(options) {
      this.shell = options.shell;
    }, 

    render: function() {
      if(this.model.get("as") == "open") {
        window.open(this.model.get("result").path);
      } else {
        EcmaSh.BaseView.prototype.render.apply(this);
      }
      return this;
    }

  });


}(EcmaSh));
