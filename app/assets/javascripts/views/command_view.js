(function(EcmaSh) {

  EcmaSh.CommandView = EcmaSh.BaseView.extend({
    className: "line",
    template: "command",
    initialize: function() {
      this.model.on("ran error",this.removeRunning,this);
    },

    render: function() {
      EcmaSh.BaseView.prototype.render.apply(this);
      return this;
    },
     
    removeRunning: function() {
      this.$(".running").remove();

    }
  });


}(EcmaSh));
