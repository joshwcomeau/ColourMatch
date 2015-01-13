function ReadImageContents($q) {

  this.call = function(photo) {
    var deferred = $q.defer();
    var reader = new FileReader();
    reader.onload = function () { deferred.resolve(reader.result); };
    reader.onerror = function () { deferred.reject(); };
    try {
      reader.readAsDataURL(photo[0]);
    } catch (e) {
      deferred.reject(e);
    }
    return deferred.promise;    
  };
}


angular.module('colourMatch').service("ReadImageContents", ["$q", ReadImageContents]);