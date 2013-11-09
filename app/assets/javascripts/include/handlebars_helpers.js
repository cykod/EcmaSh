

Handlebars.registerHelper('line', function(promptLine, value, options) {
  var str = "<div class='line'>";

  if(value) {
    str += "<label>" + promptLine + "</label> <div class='command'>" + value + "</div>";
  } else {
    str +=  "<label>" + promptLine + "</label> <div contenteditable=true class='prompt'>&nbsp;</div>";
  }

  str += "</div>";

  return new Handlebars.SafeString(str);
});
