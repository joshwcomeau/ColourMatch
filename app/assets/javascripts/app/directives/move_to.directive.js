// NOT USED. Will be deleted shortly.

// function deferClickTo($q) {
//   return {
//     restrict: 'A',
//     link: function(scope, element, attrs) {
//       var side      = attrs.side,
//           deferred  = $q.defer(),
//           activeCol, activeCard, otherCol, otherCard;

//       activeCol   = $(side === 'left'  ? '#left-col'     : '#right-col');
//       activeCard  = $(side === 'left'  ? '.photo-upload' : '.colour-select');
//       otherCol    = $(side === 'right' ? '#left-col'     : '#right-col');
//       otherCard   = $(side === 'right' ? '.photo-upload' : '.colour-select');


//       element.click(function() {
//         // First thing to do is remove any pre-existing animation settings, to clean up.
//         activeCard.removeClass("animated fadeInUp");
//         otherCard.removeClass("animated fadeInUp");

//         // Next, simultaneously fade out the unimportant section and start any necessary adjustments to the active section
//         otherCard.fadeOut(500, function() {
          
//         });

//       });
//     }
//   };
// }
//  // ng-class="{c6: dash.manager.state === 0, c3: dash.manager.state !== 0 &amp;&amp; dash.manager.mode === 'photo', c9: dash.manager.state !== 0 &amp;&amp; dash.manager.mode === 'colour'}"

// angular.module('colourMatch').directive('deferClickTo', ['$q', deferClickTo]);