function exampleDirective($document) {
  return {
    restrict: 'A',
    link: function() {
      
    }
  };
}


angular.module('colourMatch').directive('exampleDirective', ['$document', exampleDirective]);