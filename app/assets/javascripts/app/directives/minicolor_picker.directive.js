function minicolorPicker() {
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function(scope, element, attrs, ngModel) {
      var clean = true;
      var settings = {
        inline:     true,
        position:   'top left',
        letterCase: 'uppercase',
        change:     function(hex) {
          $(".colour-preview").css("background-color", hex);
          if (clean) {
            $(".colour-preview, .minicolors-input").slideDown(500, function() {
              $(".submit-button-wrapper").slideDown();
            });
            clean = false;
          }
        }
      };

      element.minicolors(settings);
    }
  };
}


angular.module('colourMatch').directive('minicolorPicker', [minicolorPicker]);