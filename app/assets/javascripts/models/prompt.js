;(function(EcmaSh) {

  EcmaSh.Prompt = Backbone.Model.extend({

    defaults: {
      PROMPT: "{{CWD}} $ "
    },

    props: function() {
      return _.defaults(this.shell.toJSON(),this.defaults);
    },

    initialize: function(attributes,options) {
      this.shell = options.shell;
    },

    promptLine: function() {
      var props = this.props();
      var line =  Handlebars.compile(props.PROMPT)(props);
      return line;
    },

    runCommand: function() {
      var self = this;
      var commandLine = this.get("prompt").trim();
      this.shell.runLine(this.promptLine(),commandLine);
    },

    cancelAutocomplete: function() {
      this.runningAutocomplete = false;
      this.autocompletes = null;

    },

    runAutocomplete: function(pos) {
      var self = this;
      if(this.runningAutocomplete) { return; }

      if(this.autocompletes && this.autocompletes.length > 1) {
        var first = this.autocompletes.shift();
        this.autocompletes.push(first);
        return this.setAutocomplete();
      }

      var commandLineParts = this.get("prompt").split(" ");

      var num = 0;
      var cur = commandLineParts[num]
      while((pos -= cur.length + 1) > 0 && cur) {
        num += 1;
        cur = commandLineParts[num]
      }
      this.set("argNum",num);

      this.autoCompleteParts = cur.split("/");

      this.runningAutocomplete = true;

      this.shell.runCommand("autocomplete",[ $.trim(cur) ],function(model) {
        if(model.get("result")) {
          self.autocompletes = model.get("result");
          if(self.autocompletes) { self.setAutocomplete(); }
        }
        self.runningAutocomplete = false;
      });

    },

    setAutocomplete: function() {
      var commandLineParts = this.get("prompt").split(" ");

      this.autoCompleteParts[this.autoCompleteParts.length - 1] = this.autocompletes[0].name;
      commandLineParts[this.get("argNum")] = this.autoCompleteParts.join("/");

      this.set("prompt",commandLineParts.join(" "));

      var pos = commandLineParts[0].length;
      for(var i = 1; i <= this.get("argNum");i++) {
        pos += 1 + commandLineParts[i].length;
      }

      this.trigger("reposition",pos);
    }
  });
}(EcmaSh));


