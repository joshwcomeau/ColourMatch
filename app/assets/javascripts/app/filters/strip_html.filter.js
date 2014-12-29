angular.module('colourMatch').
  filter('stripHtml', function() {
    return function(text) {
      return String(text).replace(/<[^>]+>/gm, '');
    }
  }
);