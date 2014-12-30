function followScroll($window) {
  return {
    restrict: 'A',
    link: function(scope, element, attrs) {
      var position       = 'relative',
          initial_offset = attrs.initialOffset || element.offset().top;

      $($window).on("scroll", function() {

        // See if we need to switch into fixed
        if ( shouldItBeFixed() && position === 'relative' ) {
          setWidthToParent(element)
          element.addClass("fixed-from-top");
          position = 'fixed';
        } else if ( !shouldItBeFixed() && position === 'fixed' ) {
          element.removeClass("fixed-from-top");
          position = 'relative';
        }
      });

      
      $($window).on("resize", function() {
        if ( position === 'fixed' ) 
          setWidthToParent(element)
        else
          element.removeAttr("style");
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