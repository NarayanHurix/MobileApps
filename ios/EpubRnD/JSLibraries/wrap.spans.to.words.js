function bindDocumentTouch()
{
    $(document).bind('touchstart',onTouchStart);
    
    $(document).bind('touchend',onTouchEnd);
    
    $(document).bind('touchmove',onTouchMove);
    
    NSLog('bind successfull');
}

function unbindDocumentTouch()
{
    $(document).unbind('touchstart');
    $(document).unbind('touchmove');
    $(document).unbind('touchend');
    NSLog('unbind successfull');
}

$(function() {
   looper($('body'));
});

function isLooped($el) {
  return $($el[0].querySelectorAll('span')).filter(function() { return this.id.match(/p[0-9]+-textid[0-9]+/); }).length > 0;
}

function looper($el) {
  var counter = 0, blnValidNode = true, text = '';

  if (isLooped($el)) return false;

  (function loop($dom) {
    if ($dom.get(0).tagName.toLowerCase() === 'a' && $dom.get(0).href !== "") {
      counter++;
      $dom.wrapInner('<span id="' + counter + '"/>');
    } else {
      $dom.contents().each(function() {
        blnValidNode = isValidNode($(this).parent());

        // Text
        if (this.nodeType === 3 && blnValidNode) {
          var arrText = $.trim($(this).text()) === '' ? $(this).text() : $(this).text().replace(/[\r\n]/ig, '<br/>'),
              arrText = arrText.replace(/\s+/g,' ').split(' '),
              lenText = arrText.length,
              containSpace = false;

          if (arrText.length === 1 && $(this).parent().get(0).tagName.toLowerCase() === 'span') {
            counter++;
            $(this).parent().attr('id', 'wordID-' + counter);
          } else {
            arrText.forEach(function(text, i) {
              if (text.replace(/[\r\n]/g, '').length > 0) {
                if (this.nodeType === 1) {
                  loop($(this));
                } else {
                  counter++;
                  arrText[i] = '<span id="wordID-' + counter + '">' + ( containSpace ? ' ' : '' ) + arrText[i] + ( i < lenText - 1 ? ' ' : '' ) + '</span>';
                }
                containSpace = false;
              } else if (text === '' && i === 0) {
                containSpace = true;
              }
            });
          }

          // Bug in Chrome
          // http://bugs.jquery.com/ticket/12505
          try {
            text = arrText.join('');
            $(this).replaceWith(text === '' ? ' ' : text);
          } catch(e) {
            if (e.code === 12) {
              try {
                text = arrText.join('');
                $(this).replaceWith($('<span/>').html(text === '' ? ' ' : text));
              } catch(e) {
                console.log(e);
              }
            }
          }
        } else if (this.nodeType === 1 && blnValidNode) {
          loop($(this));
        }
      });
    }
  })($el);

  function isValidNode($node) {
    var nodeName = $node.get(0).nodeName.toLowerCase(),
        arrInValidTags = ['script', 'code', 'textarea', 'select'],
        isTransformed = $node.css('transform') !== "none";
    
    return arrInValidTags.indexOf(nodeName) === -1 && !isTransformed ? true : false;
  }
  
}
var startWordID = -1;
var endWordID = -1;
function onTouchStart(e)
{
    startWordID = -1;
    endWordID = -1;
    e.preventDefault();
    highlightSwitch = true;
    var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
    var obj = document.elementFromPoint(touch.pageX,touch.pageY);
    if($(obj).is('span'))
    {
        var spanIDNumber = obj.id.split('-')[1];
        NSLog('start word id : '+spanIDNumber);
        startWordID =spanIDNumber;
    }
};

function onTouchEnd(e)
{
    e.preventDefault();
    highlightSwitch = false;
    var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
    var obj = document.elementFromPoint(touch.pageX,touch.pageY);
    if($(obj).is('span'))
    {
        var spanIDNumber = obj.id.split('-')[1];
        NSLog('end word id : '+spanIDNumber);
        endWordID =spanIDNumber;
    }
    startWordID = -1;
    endWordID = -1;
};

function onTouchMove(e)
{
    e.preventDefault();
    var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
    var obj = document.elementFromPoint(touch.pageX,touch.pageY);
    if(highlightSwitch)
    {
        if($(obj).is('span'))
        {
            var spanIDNumber = obj.id.split('-')[1];
            NSLog('current word id : '+spanIDNumber);
            endWordID = spanIDNumber;
            if(startWordID>endWordID)
            {
                //swap with using extra variable
                startWordID = startWordID+endWordID;
                endWordID = startWordID-endWordID;
                startWordID = startWordID - endWordID;
            }
            for(var i=startWordID;i<=endWordID;i++)
            {
                var spanIdToHighlight = 'wordID-'+i;
                $('#'+spanIdToHighlight).css('background-color','green');
            }
        }
    }
};


    
