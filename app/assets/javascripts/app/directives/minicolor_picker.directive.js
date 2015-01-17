function minicolorPicker() {
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function(scope, element, attrs, ngModel) {
      var clean = true, 
          initialized = false;

      var settings = {
        inline:         true,
        position:       'top left',
        letterCase:     'uppercase',
        animationSpeed: 100,
        change: function(hex) {
          // $(".colour-preview, .colour-selection").css("background-color", hex);
          if (clean && initialized) {
            $(".colour-preview, .minicolors-input").slideDown(500, function() {
              $(".submit-button-wrapper").slideDown();
            });
            clean = false;
          }
        }
      };

      element.minicolors(settings);
      element.minicolors('value', '#DC3522');

      initialized = true;

    }
  };
}


angular.module('colourMatch').directive('minicolorPicker', [minicolorPicker]);