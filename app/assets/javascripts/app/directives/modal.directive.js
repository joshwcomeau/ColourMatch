function modal($window) {
  return {
    restrict: 'A',
    link: function(scope, element, attrs) {
      element.on("click", function(e) {
        if ( e.target.className.split(" ")[0] == 'modal' ) {
          scope.$apply(function() {
            scope.dash.manager.comparison = null;
          });
        }
      });
    }
  };
}

modal.$inject = ['$window'];
angular.module('colourMatch').directive('modal', ['$window', modal]);