function minicolorPicker() {
  return {
    restrict: 'A',
    require: 'ngModel',
    priority: 1,
    link: function(scope, element, attrs, ngModel) {
      var settings = {
        inline: true
      }
      element.minicolors(settings);
      console.log("Minico");
    }
  };
}


angular.module('colourMatch').directive('minicolorPicker', [minicolorPicker]);