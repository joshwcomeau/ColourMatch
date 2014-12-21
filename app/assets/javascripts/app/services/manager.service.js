function Manager() {
  this.state   = 0;
  this.states  = {
    idle:          0,
    uploading:     1,
    done:          2
  };

  this.photo   = null;
  this.palette = null;

  this.colour  = null;

  

}

angular.module('colourMatch').service("Manager", [Manager]);