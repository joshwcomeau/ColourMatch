function DashboardController($scope, $attrs, $window, Manager ) {
  var dash = this
  this.auth         = $attrs.authToken;
  this.manager      = Manager;

  // When we've finished uploading our photo or sending our color, Manager.state becomes '2'.
  // At this point, we need to grab our colour(s) and open an SSE stream.
  // Unfortunately, this needs to be done in the controller, since $scope.$apply needs to be called.
  $scope.$watch(angular.bind(this, function () {
    return this.manager.state
  }), function (newVal, oldVal) {
    if (newVal === 2) {
      dash.listenForResponse(Manager.requestPath);
      // Enable our follow-scroll directive. This probably isn't the best way to do this,
      // come back and refactor me when you find a better way?
      $(".follower").attr("enabled", true);
    }
  });

  this.listenForResponse = function(link) {
    source = new EventSource(link);
    console.log("Listening for response from ", link)

    source.onmessage = function(event) {
      var data = event.data
      if (data === 'OVER') {
        console.log("Closing.");
        source.close();
      } else {
        $scope.$apply(function() {
          Manager.photos.push(JSON.parse(data));  
        });
      }
    };
  };
}


DashboardController.$inject = ['$scope', '$attrs', '$window', 'Manager'];
angular.module('colourMatch').controller('DashboardController', ['$scope', '$attrs', '$window', 'Manager', DashboardController]);