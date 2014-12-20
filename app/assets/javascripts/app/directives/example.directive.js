function deferClickTo() {
  return {
    restrict: 'A',
    link: function(destination) {
      $(destination).click();
    }
  };
}


angular.module('colourMatch').directive('deferClickTo', [deferClickTo]);