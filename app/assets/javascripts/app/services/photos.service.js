function Photos($resource) {
  return $resource('/photos/');
}

angular.module('colourMatch').factory("Photos", ["$resource", Photos]);