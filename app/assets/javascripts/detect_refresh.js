var keys = [];

function disableRefreshShortcut(e) {
  e = e || event;
  keys[e.keyCode] = e.type == 'keydown';
  /*insert conditional here*/
  console.log(keys);

  if ( keys[82] && (keys[93] || keys[91]) ) {
    e.preventDefault();
    window.location = location;
    return false;
  }
}

$(document).on("keydown keyup", disableRefreshShortcut);