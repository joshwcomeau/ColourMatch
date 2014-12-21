function Manager(UploadPhoto, SendColour) {
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
    Manager.state = Manager.states.uploading;
    Manager.mode  = type;

    if (type == 'photo') {
      UploadPhoto.call(search, token)
      .success(function(data, status, headers, config) {
        // file is uploaded successfully
        Manager.photo   = config.file;
        Manager.palette = data;
        Manager.state   = Manager.states.done;
      });
      //.error(...)
      //.then(success, error, progress); // returns a promise that does NOT have progress/abort/xhr functions
      //.xhr(function(xhr){xhr.upload.addEventListener(...)}) // access or attach event listeners to the underlying XMLHttpRequest
    
    } else if (type == 'colour') {
      SendColour.call(search, token)
      .$promise.then(function(success_result) {
        console.log(success_result);
        Manager.state   = Manager.states.done;
      }, function(error_result) {
        console.log(error_result);
      });
    }
  };

}

angular.module('colourMatch').service("Manager", ["UploadPhoto", "SendColour", Manager]);