(function(EcmaSh) {

  EcmaSh.LoginView = EcmaSh.BaseView.extend({
    template: "login",

    events: {
      "keydown .prompt": "checkSubmit",
      "click": "focusPrompt"
    },

    initialize: function() {
    },

    render: function() {
      EcmaSh.BaseView.prototype.render.apply(this);
      return this;
    },


    checkSubmit: function(e) {
      if(this.pressedEnter(e)) { 

        var value = this.$(".prompt").text().trim();

        if(!this.hasUsername()) { 
          this.setUsername(value);
        } else if(!this.hasPassword()) {
          this.setPassword(value);
        }
        
      }

    },

    hasUsername: function() { return this.model.get("username"); },
    hasPassword: function() { return this.model.get("password"); },

    setUsername: function(value) {
      if(value == 'guest' || value == 'register') {
        this.model.set({ state: value });
      } else {
        this.model.set("username",value);
      }
      this.render();
      this.$(".prompt").focus();
    },

    setPassword: function(value) {
      this.model.set("password",value);
      this.render();
      this.model.save();
    }

  });


}(EcmaSh));

