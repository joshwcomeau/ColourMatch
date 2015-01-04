function disableRefreshShortcut(e) {
  e = e || event;
  keys[e.keyCode] = e.type == 'keydown';

  if ( keys[82] && (keys[93] || keys[91]) ) {
    e.preventDefault();
    window.location = location;
    return false;
  }
}

var keys = [];

$(document).on("keydown keyup", disableRefreshShortcut);