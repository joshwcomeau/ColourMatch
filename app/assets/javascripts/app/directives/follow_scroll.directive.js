function followScroll($window) {
  return {
    restrict: 'A',
    link: function(scope, element, attrs) {
      var position       = 'relative',
          initial_offset = attrs.initialOffset || element.offset().top,
          initial_width;
      
      $($window).on("scroll", function() {

        // See if we need to switch into fixed
        if ( $($window).scrollTop() >= (initial_offset - attrs.minScrollTop) && position === 'relative' ) {
          // Set its width to whatever it currently is.
          initial_width = element.width();
          element.width(initial_width);

          element.addClass("fixed-from-top");
          position = 'fixed';
        } else if ( $($window).scrollTop() < (initial_offset - attrs.minScrollTop) && position === 'fixed' ) {
          element.removeClass("fixed-from-top");
          element.removeAttr("style");
          position = 'relative';
        }
      })
    }
  };
}

followScroll.$inject = ['$window'];
angular.module('colourMatch').directive('followScroll', ['$window', followScroll]);