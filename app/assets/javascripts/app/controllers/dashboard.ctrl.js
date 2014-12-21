function DashboardController($scope, $attrs, Manager, UploadPhoto, SendColour ) {
  var dash = this
  this.auth         = $attrs.authToken;
  this.manager      = Manager;
  this.uploadPhoto  = UploadPhoto;
  this.sendColour   = SendColour;
  this.photos       = [];

  $scope.$watch(angular.bind(this, function () {
    return this.manager.photos; // `this` IS the `this` above!!
  }), function (newVal, oldVal) {
    dash.manager.photos = newVal
    console.log(newVal);
  }, true);

}





DashboardController.$inject = ['$scope', '$attrs', 'Manager', 'UploadPhoto', 'SendColour'];
angular.module('colourMatch').controller('DashboardController', ['$scope', '$attrs', 'Manager', 'UploadPhoto', 'SendColour', DashboardController]);