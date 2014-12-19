function PhotosController($scope, $upload) {
  $scope.$watch('photo', function() {
    var file = $scope.photo;
    $scope.upload = $upload.upload({
      url: '/photos/', // upload.php script, node.js route, or servlet url
      method: 'POST',

      data: {photo: $scope.photo},
      file: file, // single file or a list of files. list is only for html5
      //fileName: 'doc.jpg' or ['1.jpg', '2.jpg', ...] // to modify the name of the file(s)
      fileFormDataName: "photo", 
      //formDataAppender: function(formData, key, val){}  // customize how data is added to the formData. 
                                                          // See #40#issuecomment-28612000 for sample code

    }).progress(function(evt) {
      console.log(evt);
    }).success(function(data, status, headers, config) {
      // file is uploaded successfully
      console.log('file ' + config.file.name + 'is uploaded successfully. Response: ' + data);
    });
    //.error(...)
    //.then(success, error, progress); // returns a promise that does NOT have progress/abort/xhr functions
    //.xhr(function(xhr){xhr.upload.addEventListener(...)}) // access or attach event listeners to the underlying XMLHttpRequest
  });
}





PhotosController.$inject = ['$scope', '$upload'];
angular.module('colourMatch').controller('PhotosController', ['$scope', '$upload', PhotosController]);