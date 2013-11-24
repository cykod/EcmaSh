(function(EcmaSh) {

  EcmaSh.Shell = Backbone.Model.extend({
    initialize: function(attributes,options) {

      this.session = options.session;

      this.set(this.session.get("env"))
      this.user = new EcmaSh.User(this.session.get("user"));

      this.history = new EcmaSh.History();

      this.on("logout",this.session.clear,this.session);
      this.on("logout",this.user.clear,this.user);
    },

    remember: function() {
      this.session.save(this,this.user);
    },

    addToHistory: function(promptLine,input,command) {
      this.history.add(new EcmaSh.CommandLine({ promptLine: promptLine, input: input}, { command: command }));

    },

    runLine: function(promptLine, input) {

      // Split out into multiple commands (via split on ;, | )
      // change together if necessary
      var argv = input.split(" ");
      var name = argv.shift();
      var command = this.runCommand(name,argv);

      // Add the command line history
      this.addToHistory(promptLine,input,command);
      return command;
    },

    runCommand: function(name,argv,callback) {
      var command = EcmaSh.Command.run(name, this, { 
        command: name,
        argv: argv
      });
      if(callback) { 
        command.on("ran",callback);
        command.on("error",callback);
      }
      return command;
    }
  });


}(EcmaSh));
