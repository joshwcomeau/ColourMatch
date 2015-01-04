function GlobalController($scope, Manager ) {
  this.manager      = Manager;
}


GlobalController.$inject = ['$scope', 'Manager'];
angular.module('colourMatch').controller('GlobalController', ['$scope', 'Manager', GlobalController]);