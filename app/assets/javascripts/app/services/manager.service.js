function Manager($timeout, UploadPhoto, ReadImageContents, SendColour) {
  var Manager  = this;
  this.states  = {
    idle:          0,
    uploading:     1,
    done:          2,
    error:         3
  };
  this.hex_regex = /^#?([0-9A-F]{6}|[0-9A-F]{3})$/i;

  if (gon.suggestions) {
    this.suggestions = gon.suggestions;
  }

  this.initialize = function() {
    this.state          = 0;
    this.photos         = [];
    this.mode           = null; // Either 'photo' or 'colour'  
    this.photo          = null; // The locally stored photo file.
    this.preview        = null;
    this.palette        = null;
    this.closestColour  = null;
    this.requestPath    = "/photos";
    this.allComplete    = false;
    this.flash          = {
      message:  null,
      details:  null,
      type:     null
    };

    // Ugh, I hate that I need to do this here, but ng-animations are buggy.
    $(".left-side-wrapper, .colour-select").attr("style", "").attr("enabled", "false");

  };


  this.requestImages = function(search, token, type) {
    var request_string;

    Manager.state = Manager.states.uploading;
    Manager.mode  = type;

    if (type == 'photo') {
      // Display the preview to the user
      ReadImageContents.call(search)
      .then(function(photoData) {
        Manager.preview = 'url(' + photoData + ')';
      })
      .catch(function(error) {
        alert("Oh no! We had trouble reading the image you selected. Things may be broken. You might want to refresh and try again.");
      });    

      // Send the photo to the server
      UploadPhoto.call(search, token)
      .success(function(data, status, headers, config) {
        // file is uploaded successfully
        Manager.photo         = config.file;
        Manager.palette       = data.colours;
        Manager.stats         = data.stats;


        Manager.requestPath += "?mode_data=" + data.photo.id + "&mode=photo";

        // The second server request happens when Manager.state gets updated in Manager#updateAfterInterval.
        // There's a watch function in dash.ctrl.js
        Manager.updateAfterInterval(Manager.states.done, 700);

      })
      .error(function(data, status, headers, config) {
        // Reset to initial state
        $timeout(function() {
          Manager.initialize(); 
          if ( status == 415 ) {
            Manager.flash.message = "Please upload a valid image!";
            Manager.flash.details = "We accept JPG/JPEG, GIF, and PNG images.";
            Manager.flash.type    = "error";
          }
        }, 500);
      });
    
    } else if (type == 'colour') {
      // Validations
      if ( Manager.hex_regex.test(Manager.colour) ) {

        SendColour.call(search, token)
        .$promise.then(function(successResult) {
          Manager.closestColour = successResult.closest_colour;

          Manager.requestPath  += "?mode_data=" + Manager.colour.replace("#", "") + "&mode=colour";
          
          
          // The second server request happens when Manager.state gets updated in Manager#updateAfterInterval.
          // There's a watch function in dash.ctrl.js
          Manager.updateAfterInterval(Manager.states.done, 700);
          
        }, function(errorResult) {
          console.log(errorResult);
          alert("Oh no! We ran into some trouble. Things may be broken. You might want to refresh and try again.");
        });
      } else {
        Manager.initialize(); 
        Manager.flash.message = "Please select a valid colour!";
        Manager.flash.details = "Use the colourpicker, or enter a valid hex color code (eg. #123456)";
        Manager.flash.type    = "error";
      }
    }
  };

  this.updateAfterInterval = function(desiredState, timeToWait) {

    $timeout(function() {
      Manager.state = desiredState;
    }, timeToWait)
  };

  this.useSuggestion = function(data) {
    Manager.suggestion  = data;
    Manager.mode        = "photo";
    Manager.palette     = data.palette;
    Manager.stats       = data.photo;
    Manager.state       = Manager.states.uploading;
    Manager.requestPath  += "?mode_data=" + data.photo.id + "&mode=photo"; 
    Manager.preview     = 'url(' + data.photo.image.url + ')';

    Manager.updateAfterInterval(Manager.states.done, 220);
  }

}

angular.module('colourMatch').service("Manager", ["$timeout", "UploadPhoto", "ReadImageContents", "SendColour", Manager]);