(function(EcmaSh) {

  EcmaSh.ResultView = EcmaSh.BaseView.extend({
    className: "result",
    template: "result",

    initialize: function() {
      console.log(this.model.get("result"));

      if(HandlebarsTemplates["result-" + this.model.get("type")]) {
        this.template = ["result-" + this.model.get("type")];
        this.custom = true;
      } 
    },

    render: function() {
      var json = null;

      if(!this.custom) {
        json = _.extend(this.model.toJSON(), { json: JSON.stringify(this.model.get("result"), undefined, 2) });
      } else {
        json = this.model.toJSON();
      }

      this.$el.empty().html(this.tmpl(json));

      return this;
    }
  });

}(EcmaSh));
