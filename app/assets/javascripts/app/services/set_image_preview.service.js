function SetImagePreview() {
  var serv = this;

  this.call = function(photo) {
    if (!photo || !window.FileReader) return; // No file selected, or no fileReader support

    var reader = new FileReader();

    reader.readAsDataURL(photo[0]);

    reader.onloadend = function(e) {
      $(".photo_box").css('background-image', 'url('+e.target.result +')');

      // var filename = $input.val().split('\\').pop();
      // $('.photo-cover').val(filename);
    }

  };


}

angular.module('colourMatch').service("SetImagePreview", [SetImagePreview]);