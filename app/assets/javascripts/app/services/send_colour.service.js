function SendColour($resource, Manager) {
  var serv      = this,
      resource  = $resource('/colours')


  this.call = function(colour, token) {
    SetImagePreview.call(photo);
    Manager.state = Manager.states.uploading;
    
    return $upload.upload({
      url: '/photos/',
      method: 'POST',
      data: {photo: photo, authenticity_token: token},
      file: photo, 
      fileFormDataName: "photo", 
      formDataAppender: function(formData) {
        formData.append("authenticity_token", token);
        formData.append("photo", photo);
      } 

    }).progress(function(evt) {
      console.log(evt);
    }).success(function(data, status, headers, config) {

      // file is uploaded successfully
      Manager.photo   = config.file;
      Manager.palette = data;

    });
    //.error(...)
    //.then(success, error, progress); // returns a promise that does NOT have progress/abort/xhr functions
    //.xhr(function(xhr){xhr.upload.addEventListener(...)}) // access or attach event listeners to the underlying XMLHttpRequest

  };


}

angular.module('colourMatch').service("SendColour", ["$resource", "Manager", SendColour]);