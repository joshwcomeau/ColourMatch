function DashboardController($scope, $attrs, Manager, UploadPhoto, SendColour ) {
  var dash = this
  this.auth         = $attrs.authToken;
  this.manager      = Manager;
  this.uploadPhoto  = UploadPhoto;
  this.sendColour   = SendColour;

  this.photos       = [];

  // When we've finished uploading our photo or sending our color, Manager.state becomes '2'.
  // At this point, we need to grab our colour(s) and open an SSE stream.
  // Unfortunately, this needs to be done in the controller, since $scope.$apply needs to be called.
  $scope.$watch(angular.bind(this, function () {
    return this.manager.state
  }), function (newVal, oldVal) {
    if (newVal === 2) {
      dash.listenForResponse(Manager.requestPath);
    }
  });




  this.listenForResponse = function(link) {
    source = new EventSource(link);
    
    source.addEventListener('message', function(event) {
      var data = event.data
      if (data === 'OVER') {
        source.close();
      } else {
        $scope.$apply(function() {
          Manager.photos.push(data);  
        });
      }
    });
  };
}


DashboardController.$inject = ['$scope', '$attrs', 'Manager', 'UploadPhoto', 'SendColour'];
angular.module('colourMatch').controller('DashboardController', ['$scope', '$attrs', 'Manager', 'UploadPhoto', 'SendColour', DashboardController]);