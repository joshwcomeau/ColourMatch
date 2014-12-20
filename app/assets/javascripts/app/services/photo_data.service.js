function PhotoData() {
  this.photo = null;
  this.palette = null;
}

angular.module('colourMatch').service("PhotoData", [PhotoData]);