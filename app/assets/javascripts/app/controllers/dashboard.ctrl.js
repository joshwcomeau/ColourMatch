function DashboardController($scope, $attrs, Manager, UploadPhoto, SendColour ) {
  this.auth         = $attrs.authToken;
  this.manager      = Manager;
  this.uploadPhoto  = UploadPhoto;
  this.sendColour   = SendColour;

}





DashboardController.$inject = ['$scope', '$attrs', 'Manager', 'UploadPhoto', 'SendColour'];
angular.module('colourMatch').controller('DashboardController', ['$scope', '$attrs', 'Manager', 'UploadPhoto', 'SendColour', DashboardController]);