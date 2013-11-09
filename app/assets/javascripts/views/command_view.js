(function(EcmaSh) {

  EcmaSh.CommandView = EcmaSh.BaseView.extend({
    className: "line",
    template: "command",
    initialize: function() {

    },

    render: function() {
      EcmaSh.BaseView.prototype.render.apply(this);
      return this;
    }

  });


}(EcmaSh));
