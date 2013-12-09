(function(EcmaSh) {

 EcmaSh.SourceResultView = EcmaSh.BaseView.extend({
   template: "result-source",
    initialize: function() {
    },

    render: function() {

      var errorFunc = function(e) { 
        console.log(e);
        return true;
      };

      $(window).on("error",errorFunc);

      var s = document.createElement('script');
      s.type = 'text/javascript';
      s.src = this.model.get("result").path;


      this.$el.empty().append(s);

      //this.$el.empty()[0].appendChild(s);
      $(window).off("error",errorFunc);

    },


  });


}(EcmaSh));
