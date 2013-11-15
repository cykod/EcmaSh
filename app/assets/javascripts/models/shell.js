(function(EcmaSh) {

  EcmaSh.Shell = Backbone.Model.extend({
    initialize: function(attributes,options) {

      this.session = options.session;

      this.set(this.session.get("env"))
      this.user = new EcmaSh.User(this.session.get("user"));

      this.history = new EcmaSh.History();
    },

    runLine: function(promptLine, input) {

      // Split out into multiple commands (via split on ;, | )
      // change together if necessary
      var argv = input.split(" ");
      var name = argv.shift();
      var command = this.runCommand(name,argv);

      // Add the command line history
      this.history.add(new EcmaSh.CommandLine({ promptLine: promptLine, input: input}, { command: command }));
    },

    runCommand: function(name,argv) {
      var command = EcmaSh.Command.run(name, this, { 
        command: command,
        argv: argv
      });
      return command;
    }
  });


}(EcmaSh));
