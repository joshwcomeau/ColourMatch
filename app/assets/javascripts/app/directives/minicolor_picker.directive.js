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
            $(".colour-preview, .minicolors-input").slideDown();
          }
        }
      };

      element.minicolors(settings);

      // Create the color preview div
      element.before('<div class="colour-preview"></div>')
    }
  };
}


angular.module('colourMatch').directive('minicolorPicker', [minicolorPicker]);