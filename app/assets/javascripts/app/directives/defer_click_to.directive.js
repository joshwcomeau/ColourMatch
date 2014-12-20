function deferClickTo() {
  return {
    restrict: 'A',
    link: function(scope, element, attrs) {
      element.click(function() {
        $(attrs.destination).click();
      });
    }
  };
}


angular.module('colourMatch').directive('deferClickTo', [deferClickTo]);