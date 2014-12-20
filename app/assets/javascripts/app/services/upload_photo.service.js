function UploadPhoto($upload, SetImagePreview, PhotoData) {
  var serv = this;

  this.call = function(photo, token) {
    SetImagePreview.call(photo);
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
      PhotoData.photo   = config.file;
      PhotoData.palette = data;
      
      console.log('file ' + config.file.name + 'is uploaded successfully. Response: ' + data);
      console.log(data[0]);
      console.log(config);
    });
    //.error(...)
    //.then(success, error, progress); // returns a promise that does NOT have progress/abort/xhr functions
    //.xhr(function(xhr){xhr.upload.addEventListener(...)}) // access or attach event listeners to the underlying XMLHttpRequest

  };


}

angular.module('colourMatch').service("UploadPhoto", ["$upload", "SetImagePreview", "PhotoData", UploadPhoto]);