angular.module('colourMatch').
  filter('capitalize', function() {
    return function(string) {
      if (string) {
        words = string.split(" ");
        return _.map(words, function(word) {
          return word.charAt(0).toUpperCase() + word.slice(1);
        }).join(" ");
      }
    };
  }
);