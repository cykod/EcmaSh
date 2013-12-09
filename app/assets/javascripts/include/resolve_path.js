;(function(EcmaSh) {


  EcmaSh.resolvePath = function(path,cwd) {

    if(path[0] != "/") {
      path = (cwd + "/" + path);
    }
    var pathParts =  _.reject(path.split("/"), function(s) { return s == ""; });

    var finalPathParts = [];
    _.each(pathParts,function(p) {
      if(p == "..") {
        finalPathParts.pop(); 
      } else if(p != ".") {
        finalPathParts.push(p);
      }
    });

    return "/" + finalPathParts.join("/");
  }

}(EcmaSh));
