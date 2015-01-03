var refresh_prepare = 1;

function checkRefresh() {
  var today = new Date(),
      now = today.getUTCSeconds(),
      cookie = document.cookie,
      cookieArray = cookie.split('; '),
      i, nameValue, cookieTime, cookieName;

  for ( i=0; i < cookieArray.length; i++ ) {
    nameValue = cookieArray[i].split('=');

    if ( nameValue[0].toString() == 'SHTS' ) {
      cookieTime = parseInt( nameValue[1] );
    } else if ( nameValue[0].toString() == 'SHTSP' ) {
      cookieName = nameValue[1];
    }
  }

  if ( cookieName && cookieTime && cookieName == escape(location.href) && Math.abs(now - cookieTime) < 5 ) {
    document.cookie = 'SHTS=;';
    document.cookie = 'SHTSP=;';
    refresh_prepare = 0;
    window.location = location;
    return true;
  } 
}

function prepareForRefresh()
{
  if( refresh_prepare > 0 ) {
    var today = new Date();
    var now = today.getUTCSeconds();
    document.cookie = 'SHTS=' + now + ';';
    document.cookie = 'SHTSP=' + escape(location.href) + ';';
  } else {
    document.cookie = 'SHTS=;';
    document.cookie = 'SHTSP=;';
  }
}

function disableRefreshDetection()
{
  refresh_prepare = 0;
  return true;
} 





// </head>

// <body onLoad="JavaScript:checkRefresh();" onUnload="JavaScript:prepareForRefresh();">

// <!-- The above is all that is needed. -->

// <!-- Below is an example of the use of disableRefreshDetection() 
//      to prevent false refreshes from being detected when forms 
//      are submitted back to this page. If your web page does
//      not use forms that post back to themselves, then the
//      below does not matter to you. Omit it. -->

// <!-- This is a dummy form. Focus on the onSubmit. -->

// <form onSubmit="JavaScript:disableRefreshDetection()">
// <input type="submit" />
// </form>

// </body>
// </html>