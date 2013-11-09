(function(EcmaSh) {

  EcmaSh.RegisterView = EcmaSh.BaseView.extend({
    template: "register",

    events: {
      "keydown .prompt": "checkSubmit",
      "click": "focusPrompt"
    },

    initialize: function() {
    },

    render: function() {
      EcmaSh.BaseView.prototype.render.apply(this);
      this.$(".prompt").focus();
      return this;
    },


    checkSubmit: function(e) {
      if(this.pressedEnter(e)) { 

        var value = this.$(".prompt").text().trim();

        if(!this.hasUsername()) { 
          this.setUsername(value);
        } else if(!this.hasPassword()) {
          this.setPassword(value);
        } else if(!this.hasEmail()) {
          this.setEmail(value);
        }
        
      }

    },

    hasUsername: function() { return this.model.get("username"); },
    hasPassword: function() { return this.model.get("password"); },
    hasEmail: function() { return this.model.get("email"); },

    setUsername: function(value) {
      var self = this;
      this.model.checkUsername(value,function(value) {
        self.render();
      });
    },

    setPassword: function(value) {
      this.model.set("password",value);
      this.render();
    },

    setEmail: function(value) {
      this.model.set("email",value);
      this.model.save();
      this.render();
    }

  });


}(EcmaSh));

