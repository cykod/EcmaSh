(function(EcmaSh) {

  EcmaSh.Shell = Backbone.Model.extend({
    initialize: function(attributes,options) {

      this.session = options.session;

      var ecmaEnv = this.session.get("env");
      var ecmaUser = this.session.get("user");
      
      // localStorage['ecma_env'] ? JSON.parse(localStorage['ecma_env']) : {}
      //localStorage['ecma_user'] ? JSON.parse(localStorage['ecma_user']) : {}

      this.set(ecmaEnv);

      this.user = new EcmaSh.User(ecmaUser);

      this.lines = new EcmaSh.PromptHistory();
      this.history = new EcmaSh.CommandHistory();
    },

    runLine: function(promptLine, command) {
      // Add the command line history
      this.lines.add(new EcmaSh.CommandLine({ promptLine: promptLine, command: command }));

      // Split out into multiple commands (via split on ;, | )
      // change together if necessary
      var argv = command.split(" ");
      var name = argv.shift();
      this.runCommand(name,argv);
    },

    runCommand: function(name,args) {

      var command = EcmaSh.Command.run(name, this, { 
        command: command,
        argv: argv
      });

      this.history.add(command);
      return command;
    },
                                            

    cookie: function() {
      localStorage["ecma_env"] = JSON.stringify(this.toJSON());
      localStorage["ecma_user"] = JSON.stringify(this.user.toJSON());
    }
  });


}(EcmaSh));
