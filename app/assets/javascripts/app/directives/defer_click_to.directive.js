function deferClickTo() {
  return {
    restrict: 'A',
    link: function(scope, element, attrs) {
      element.click(function() {
        if ( scope.dash.manager.state === 0 ) {
          $(attrs.destination).click();
        } else {
          
        }
      });
    
    }
  };
}


angular.module('colourMatch').directive('deferClickTo', [deferClickTo]);