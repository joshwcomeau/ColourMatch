function PhotosController($scope, $attrs, UploadPhoto, PhotoData) {
  this.photo        = null;
  this.auth         = $attrs.authToken;
  this.photoData    = PhotoData;
  this.uploadPhoto  = UploadPhoto;

}





PhotosController.$inject = ['$scope', '$attrs', 'UploadPhoto', 'PhotoData'];
angular.module('colourMatch').controller('PhotosController', ['$scope', '$attrs', 'UploadPhoto', 'PhotoData', PhotosController]);