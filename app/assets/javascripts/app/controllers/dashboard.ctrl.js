function DashboardController($scope, $attrs, $window, Manager ) {
  var dash = this;

  // These two object properties are essential for use in the views.
  this.auth         = $attrs.authToken;
  this.manager      = Manager;
  
  Manager.initialize();

  // When we've finished uploading our photo or sending our color, Manager.state becomes '2'.
  // At this point, we need to grab our colour(s) and open an SSE stream.
  // Unfortunately, this needs to be done in the controller, since $scope.$apply needs to be called.
  $scope.$watch(angular.bind(this, function () {
    return Manager.state
  }), function (newVal, oldVal) {
    if (newVal === 2) {
      dash.listenForResponse(Manager.requestPath);
      // Enable our follow-scroll directive. This probably isn't the best way to do this,
      // come back and refactor me when you find a better way?
      $(".follower").attr("enabled", true);
    }
  });

  $scope.$watch(angular.bind(this, function () {
    return Manager.photo
  }), function(newVal, oldVal) {
    if ( newVal ) {
      Manager.requestImages(newVal, dash.auth, 'photo');
    }
  });

  this.listenForResponse = function(link) {
    dash.source = new EventSource(link);

    dash.source.addEventListener('photo', function(event) {
      var data = event.data
      if (data === 'OVER') {
        // Wrap me in a $scope.$apply to fix me.
        $scope.$apply(function() {
          Manager.allComplete = true;
          dash.source.close();
        });
      } else {
        $scope.$apply(function() {
          Manager.photos.push(JSON.parse(data));  
        });
      }
    });
  };

  this.restart = function() {
    Manager.initialize();
    dash.source.close();
  }
}


DashboardController.$inject = ['$scope', '$attrs', '$window', 'Manager'];
angular.module('colourMatch').controller('DashboardController', ['$scope', '$attrs', '$window', 'Manager', DashboardController]);