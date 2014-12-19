function Photos($upload) {
  var serv = this;

  this.upload = function(photo, token) {
    return $upload.upload({
      url: '/photos/', // upload.php script, node.js route, or servlet url
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
      console.log('file ' + config.file.name + 'is uploaded successfully. Response: ' + data);
    });
    //.error(...)
    //.then(success, error, progress); // returns a promise that does NOT have progress/abort/xhr functions
    //.xhr(function(xhr){xhr.upload.addEventListener(...)}) // access or attach event listeners to the underlying XMLHttpRequest

  };


}

angular.module('colourMatch').service("Photos", ["$upload", Photos]);