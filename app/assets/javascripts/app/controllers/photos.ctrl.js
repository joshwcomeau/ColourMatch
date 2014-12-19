function PhotosController($scope) {
  this.thing = "WEEEE";
}





PhotosController.$inject = ['$scope'];
angular.module('colourMatch').controller('PhotosController', ['$scope', PhotosController]);