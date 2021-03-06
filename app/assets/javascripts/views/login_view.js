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
        }
        
      }

    },

    hasUsername: function() { return this.model.get("username"); },
    hasPassword: function() { return this.model.get("password"); },

    setUsername: function(value) {
      if(value == 'guest') {
        this.model.set({ state: value });
        this.model.registerGuest();
      } else if(value == 'register') {
        this.model.set({ state: value });
      } else {
        this.model.set("username",value);
      }
      this.render();
    },

    setPassword: function(value) {
      this.model.set("password",value);
      this.render();

      var self = this;
      this.model.save({},{
        error: function(model,xhr) {
          model.set(JSON.parse(xhr.responseText));
          self.render();
        }
      });
    }

  });


}(EcmaSh));

