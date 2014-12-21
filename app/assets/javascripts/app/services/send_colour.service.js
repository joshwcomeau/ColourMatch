function SendColour($resource, Manager) {
  var serv      = this,
      resource  = $resource('/colours');


  this.call = function(c, token) {
    resource.get({colour: c, authenticity_token: token})
    .$promise.then(function(result) {
      console.log(result);
    });
  };


}

angular.module('colourMatch').service("SendColour", ["$resource", "Manager", SendColour]);