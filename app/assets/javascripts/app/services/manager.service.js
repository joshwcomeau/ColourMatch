function Manager($timeout, UploadPhoto, SendColour) {
  var Manager  = this;
  this.state   = 0;
  this.states  = {
    idle:          0,
    uploading:     1,
    done:          2
  };

  this.mode    = null; // Either 'photo' or 'colour'  

  this.photo   = null;
  this.palette = null;

  this.colour  = null;

  this.requestImages = function(search, token, type) {
    var startTime;

    Manager.state = Manager.states.uploading;
    Manager.mode  = type;
    startTime     = new Date().getTime();

    if (type == 'photo') {
      UploadPhoto.call(search, token)
      .success(function(data, status, headers, config) {
        // file is uploaded successfully
        Manager.photo   = config.file;
        Manager.palette = data;

        // Make sure this bit takes at least 500ms
        Manager.updateAfterInterval(startTime, Manager.states.done);
      });
      //.error(...)
      //.then(success, error, progress); // returns a promise that does NOT have progress/abort/xhr functions
      //.xhr(function(xhr){xhr.upload.addEventListener(...)}) // access or attach event listeners to the underlying XMLHttpRequest
    
    } else if (type == 'colour') {
      SendColour.call(search, token)
      .$promise.then(function(success_result) {
        console.log(success_result);
        Manager.updateAfterInterval(startTime, Manager.states.done);
      }, function(error_result) {
        console.log(error_result);
      });
    }
  };

  this.updateAfterInterval = function(startTime, desiredState) {
    var minTimeToWait = 1500,
        endTime, intervalLength;

    endTime = new Date().getTime();
    intervalLength = endTime - startTime;

    console.log("Upload took ", intervalLength)

    if (intervalLength < minTimeToWait) {
      $timeout(function() {
        Manager.state   = desiredState;
      }, minTimeToWait - intervalLength);
    } else { 
      Manager.state   = desiredState; 
    }
  };

}

angular.module('colourMatch').service("Manager", ["$timeout", "UploadPhoto", "SendColour", Manager]);