angular.module('colourMatch').
  filter('capitalize', function() {
    return function(word) {
      if (word) {
        return word.charAt(0).toUpperCase() + word.slice(1);
      }
    }
  }
);