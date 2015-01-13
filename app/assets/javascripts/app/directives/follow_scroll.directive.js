function followScroll($window) {
  return {
    restrict: 'A',
    link: function(scope, element, attrs) {
      var position       = 'relative',
          initial_offset = attrs.initialOffset || element.offset().top,
          enabled;

      $($window).on("scroll", function() {
        // Get updated attrs-enabled
        enabled = element.attr("enabled");

        if (enabled === 'true') {
          // See if we need to switch into fixed
          if ( shouldItBeFixed() ) {
            setWidthToParent(element)
            if ( position === 'relative' ) {
              element.addClass("fixed-from-top");
              position = 'fixed';
            }
          } else if ( !shouldItBeFixed() && position === 'fixed' ) {
            element.removeClass("fixed-from-top");
            position = 'relative';
          }
        }
      });

      
      $($window).on("resize", function() {
        if (enabled === 'true') {
          if ( position === 'fixed' ) 
            setWidthToParent(element)
          else
            element.removeAttr("style");
        }
      });

      function shouldItBeFixed() {
        return $($window).scrollTop() >= (initial_offset - attrs.minScrollTop);
      }

      function setWidthToParent(element) {
        return element.attr("style", "width: " + element.parent().width() + "px");
      }
    }
  };
}

followScroll.$inject = ['$window'];
angular.module('colourMatch').directive('followScroll', ['$window', followScroll]);