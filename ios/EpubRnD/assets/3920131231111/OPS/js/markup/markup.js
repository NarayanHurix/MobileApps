/**
 * IMPORTANT NOTE:
 * Please do not use Logical Operators such as && and || which breaks the functionality in Windows8 Device.
 *
 * @author: Amit Gharat <amit.gharat@hurix.com>
 * @modified: 29th July 2013
 * @modified: 5th August 2013
 */

function getAbsolutePath(url) {
  if ("unknown" == DetectBrowser()) {
    return url;
  } else {
    var url = url.replace("./", "");
  }
  var loc = window.location;
  var pathName = loc.pathname.substring(0, loc.pathname.lastIndexOf('/') + 1);
  return loc.href.substring(0, loc.href.length - ((loc.pathname + loc.search + loc.hash).length - pathName.length)) + url;
}

function DetectBrowser() {
  var val = navigator.userAgent.toLowerCase();
  if (val.indexOf("firefox") > -1) {
    return "firefox";
  } else if (val.indexOf("opera") > -1) {
    return "opera";
  } else if (val.indexOf("msie") > -1) {
    return "msie";
  } else if (val.indexOf("safari") > -1) {
    return "safari";
  } else {
    return "unknown";
  }
}

function loadPopup(id, type, markupUrl) {
  markupUrl = getAbsolutePath(markupUrl);
  
  if ("audio" == type) {
    audioBlob(markupUrl);
  } else if ("image" == type) {
    imageBlob(markupUrl);
  } else if ("video" == type) {
    videoBlob(markupUrl);  
  } else if ("audio_NOUI" == type) {
    audioNOUIBlob(markupUrl);    
  }
}

function stopOnHide($markupBox) {
  $markupBox.dialog({
    close: function(event, ui) {
      var $video = $(event.target).find('video');
      var $audio = $(event.target).find('audio');

      if ($video.length > 0) $video.each(function() {
        $(this)[0].pause();
      });
      if ($audio.length > 0) $audio.each(function() {
        $(this)[0].pause();
      });
    }
  });
}

function getMarkupBox(iframeId) {
  var $markupBox = '';

  // If inside iframe and device is windows8
  // IMP: Applicable only for Kitaboo ePub Reader - Windows8 Device
  if ($('[ng-app]').length > 0) {
    if (window.CONFIG.device === 'windows8') {
      $markupBox = $('#' + iframeId).contents().find('body').find('#markupBox');
    } else {
      $markupBox = $('#markupBox');
    }
  } else {
    $markupBox = $('#markupBox');
  }

  $markupBox.css('padding', '.5em 0.5em');
  return $markupBox;
}

function getBody(iframeId) {
  var $body = '';

  // If inside iframe and device is windows8
  // IMP: Applicable only for Kitaboo ePub Reader - Windows8 Device
  if ($('[ng-app]').length > 0) {
    if (window.CONFIG.device === 'windows8') {
      $body = $('#' + iframeId).contents().find('body');
    } else {
      $body = $('body');
    }
  } else {
    $body = $('body');
  }
  
  return $body;
}

function imageBlob(blob, iframeId) {
  var $markupBox = getMarkupBox(iframeId);
  var $body = getBody(iframeId);
  var bodyWidth = $body.width();
  var bodyHeight = $body.height();
  var popupWidth = 0;
  var popupHeight = 0;
  var padding = 50;
  var margin = 50;

  $markupBox
    .html("<img id='markupimage' src='" + blob + "'/>")
    .find('#markupimage').load(function() {
      popupWidth = $(this).width() + padding;
      popupHeight = $(this).height() + padding;

      // Add padding from left & right if an image is larger than viewport
      if (popupWidth > bodyWidth) {
        popupWidth = bodyWidth - margin
      }

      // Add padding from top & bottom if an image is larger than viewport
      if (popupHeight > bodyHeight) {
        popupHeight = bodyHeight - margin
      }
      
      $markupBox.dialog({
        width: popupWidth,
        height: popupHeight
      });
    }).end().dialog({});

    // Delay is important
    window.setTimeout(function() {
      $markupBox.parent('.ui-dialog').css({
        left: (bodyWidth - $markupBox.width() - padding/2) / 2,
        top: (bodyHeight - $markupBox.height() - padding/2) / 2
      }).end().show("slow");
    }, 0);
}

function audioBlob(blob, iframeId) {
  var $markupBox = getMarkupBox(iframeId);
  var $body = getBody(iframeId);
  var bodyWidth = $body.width();
  var bodyHeight = $body.height();
  var popupWidth = 0;
  var popupHeight = 0;
  var padding = 50;
  var margin = 50;

  if ($('[ng-app]').length > 0) {
    if (window.CONFIG.device === 'windows8') {
      $markupBox.html("<audio id='markupaudio' controls='controls'><source src='" + blob + "' type='audio/mp3'></source></audio>");
    }
  } else {
    var type1 = blob.replace('.ogg', '.mp3');
    var type2 = blob.replace('.mp3', '.ogg');

    $markupBox.html("<audio id='markupaudio' controls='controls'><source src='" + type1 + "' type='audio/mp3'></source><source src='" + type2 + "' type='audio/ogg'></source></audio>");
  }

  $markupBox.dialog({height: 100, width: 340});
  stopOnHide($markupBox);

  // Delay is important
  window.setTimeout(function() {
    $markupBox.parent('.ui-dialog').css({
      left: (bodyWidth - $markupBox.width() - padding/2) / 2,
      top: (bodyHeight - $markupBox.height() - padding/2) / 2
    }).end().show("slow");
  }, 0);
}

function audioNOUIBlob(blob, iframeId) {
  var $markupBox = getMarkupBox(iframeId);
  var $body = getBody(iframeId);
  var bodyWidth = $body.width();
  var bodyHeight = $body.height();
  var popupWidth = 0;
  var popupHeight = 0;
  var padding = 50;
  var margin = 50;

  if ($('[ng-app]').length > 0) {
    if (window.CONFIG.device === 'windows8') {
      $markupBox.html("<audio id='markupaudio' controls='controls'><source src='" + blob + "' type='audio/mp3'></source></audio>");
    }
  } else {
    var type1 = blob.replace('.ogg', '.mp3');
    var type2 = blob.replace('.mp3', '.ogg');

    $markupBox.html("<audio id='markupaudio' controls='controls'><source src='" + type1 + "' type='audio/mp3'></source></audio>");
  }

  $markupBox.dialog({height: 100, width: 330}).parent('.ui-dialog').hide().find('#markupaudio')[0].play();
}

function videoBlob(blob, iframeId) {
  var $markupBox = getMarkupBox(iframeId);
  var $body = getBody(iframeId);
  var bodyWidth = $body.width();
  var bodyHeight = $body.height();
  var popupWidth = 0;
  var popupHeight = 0;
  var padding = 50;
  var margin = 50;

  if ($('[ng-app]').length > 0) {
    if (window.CONFIG.device === 'windows8') {
      $markupBox.html("<video width='100%' controls='controls'><source src='" + blob + "' type='video/mp4'></source></video>");
    }
  } else {
    var type1 = blob.replace('.flv', '.mp4');

    // FLV format is not supported by VIDEO tag
    // todo: Need an alternative
    // var type2 = blob.replace('.mp4', '.flv');
    // <source src='"+vtype1+"' type='video/flv'>
    // @author: Amit Gharat dated 25th July 2013
    $markupBox.html("<video width='100%' controls='controls'><source src='" + type1 + "' type='video/mp4'></source></video>");
  }

  // Resize popup once video is loaded to avoid the scrollbars
  $markupBox.find('video').get(0).addEventListener('loadeddata', function() {
    $markupBox.dialog({height: $markupBox.find('video').height() + 65/* header's height */, width: 370});

    // Delay is important
    window.setTimeout(function() {
      $markupBox.parent('.ui-dialog').css({
        left: (bodyWidth - $markupBox.width() - padding/2) / 2,
        top: (bodyHeight - $markupBox.height() - padding/2) / 2
      }).end().show("slow");
    }, 0);
  }, false);

  $markupBox.dialog({height: 270, width: 370});
  stopOnHide($markupBox);

  // Delay is important
  window.setTimeout(function() {
    $markupBox.parent('.ui-dialog').css({
      left: (bodyWidth - $markupBox.width() - padding/2) / 2,
      top: (bodyHeight - $markupBox.height() - padding/2) / 2
    }).end().show("slow");
  }, 0);
}

