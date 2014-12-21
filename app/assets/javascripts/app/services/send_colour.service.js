function SendColour($resource) {
  var serv      = this,
      resource  = $resource('/colours');


  this.call = function(c, token) {    
    return resource.get({colour: c, authenticity_token: token});
  };


}

angular.module('colourMatch').service("SendColour", ["$resource", SendColour]);