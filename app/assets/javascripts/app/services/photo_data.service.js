function PhotoData() {
  this.photo   = null;
  this.palette = null;
  this.state   = 0;
  this.states  = {
    idle:          0,
    uploading:     1,
    done:          2
  };
  

}

angular.module('colourMatch').service("PhotoData", [PhotoData]);