;(function(window) {

  /*
   * https://github.com/dcompute/Zepto-CSRF
   * Extend Zepto's AJAX beforeSend method by setting an X-CSRFToken on any
   * 'unsafe' request methods.
   **/

  function sameOrigin (url) {
        // Url could be relative or scheme relative or absolute
        var sr_origin = '//' + document.location.host,
            origin = document.location.protocol + sr_origin;

        // Allow absolute or scheme relative URLs to same origin
        return (url == origin || url.slice(0, origin.length + 1) == origin + '/') ||
            (url == sr_origin || url.slice(0, sr_origin.length + 1) == sr_origin + '/') ||
            // or any other URL that isn't scheme relative or absolute i.e relative.
            !(/^(\/\/|http:|https:).*/.test(url));

    }


    $.extend($.ajaxSettings, {
      beforeSend : function (xhr, settings) {console.log(settings);
      if (
        !(/^(GET|HEAD|OPTIONS|TRACE)$/.test(settings.type)) &&
        sameOrigin(settings.url)
        ) {
          var token = $('meta[name="csrf-token"]').attr('content');
          xhr.setRequestHeader("X-CSRF-Token", token);
        }

      }
    }); 
  
  var EcmaSh = window.EcmaSh = window.EcmaSh || {};

  EcmaSh.Command = Backbone.Model.extend({

    initialize: function(attributes,options) {
      this.type = this.type || options.type
    },

    url: function() {
      return "/commands/" + this.type
    },

    run: function() {
      var self = this;

      this.save({}, {
        success: function() { 
          self.trigger("ran", self.get("result"));
        },
        error: function(model,xhr) { 
          var result = $.parseJSON(xhr.response)
          self.set("error",result.error)
          self.trigger("error",result.error);
        }
      });
    }
  });

  


}(window));
