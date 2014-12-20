function PhotosController($scope, $attrs, UploadPhoto, PhotoData) {
  this.photo        = null;
  this.auth         = $attrs.authToken;
  this.photoData    = PhotoData;
  this.uploadPhoto  = UploadPhoto;

  var ctrl   = this;

  // $scope.$watch(angular.bind(this, function() {
  //   return this.photo;
  // }), function(newVal, oldVal) {
  //   console.log("Watch triggered with ", newVal);
  //   if (newVal) {
  //     ctrl.state = 'uploading';
  //     console.log(newVal);
  //     $scope.upload = UploadPhoto.call(newVal, ctrl.auth);
  //   }
  // });


}





PhotosController.$inject = ['$scope', '$attrs', 'UploadPhoto', 'PhotoData'];
angular.module('colourMatch').controller('PhotosController', ['$scope', '$attrs', 'UploadPhoto', 'PhotoData', PhotosController]);