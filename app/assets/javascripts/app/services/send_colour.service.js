function SendColour($resource, Manager) {
  var serv      = this,
      resource  = $resource('/colours', {}, { post: {method: 'POST'} });


  this.call = function(c, token) {
    resource.post({colour: c, authenticity_token: token})
    .then(function(result) {
      console.log(result);
    });
  };


}

angular.module('colourMatch').service("SendColour", ["$resource", "Manager", SendColour]);