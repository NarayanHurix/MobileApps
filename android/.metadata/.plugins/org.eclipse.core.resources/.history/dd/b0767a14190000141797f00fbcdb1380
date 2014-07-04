
var highlightVosJSONObj = [];




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
var currentPageIndex= 0;

function setCurrentPageIndex(pageIndex)
{
    currentPageIndex = pageIndex;
}

var currentPageWidth = 0;

function setCurrentPageWidth(pageWidth)
{
    currentPageWidth = pageWidth;
}

var startWordID = -1;
var endWordID = -1;
var selectedText = '';
function onTouchStart(e)
{
    startWordID = -1;
    endWordID = -1;
    selectedText = '';
    
    e.preventDefault();
    highlightSwitch = true;
    var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
    var obj = document.elementFromPoint(touch.pageX-window.pageXOffset,touch.pageY-window.pageYOffset);
    if($(obj).is('span'))
    {
        var spanIDNumber = obj.id.split('-')[1];
        startWordID =spanIDNumber;
    }
};


function onTouchEnd(e)
{
    e.preventDefault();
    highlightSwitch = false;
//    var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
//    var obj = document.elementFromPoint(touch.pageX-window.pageXOffset,touch.pageY-window.pageYOffset);
//    if($(obj).is('span'))
//    {
//        var spanIDNumber = obj.id.split('-')[1];
//        endWordID =spanIDNumber;
//    }
    var jsonSaveHighlight = '{"MethodName":"saveTextHighlight","MethodArguments":{"arg1":"'+startWordID+'","arg2":"'+endWordID+'","arg3":"'+selectedText+'"}}';
    callNativeMethod('jstoobjc:'+jsonSaveHighlight);
    
    var currHighlightVO = {};
    
    currHighlightVO['startWordID'] = startWordID;
    currHighlightVO['endWordID'] = endWordID;
    
    highlightVosJSONObj.push(currHighlightVO);
    
    drawSavedHighlights();
    
    startWordID = -1;
    endWordID = -1;
    selectedText = '';
};
var lastHoverdWordID = -1;
function onTouchMove(e)
{
    e.preventDefault();
    var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
    var obj = document.elementFromPoint(touch.pageX-window.pageXOffset,touch.pageY-window.pageYOffset);
    if(highlightSwitch)
    {
        if($(obj).is('span'))
        {
            var spanIDNumber = obj.id.split('-')[1];
            if(lastHoverdWordID != spanIDNumber)
            {
                
                
                if(Number(lastHoverdWordID)>Number(spanIDNumber))
                {
                    //moving backward
                    if(Number(spanIDNumber)<Number(startWordID))
                    {
                        //crossed start word
                        startWordID = spanIDNumber;
                    }
                    else
                    {
                        endWordID = spanIDNumber;
                    }
                }
                else
                {
                    //moving forward
                    if(Number(spanIDNumber)>Number(endWordID))
                    {
                        //crossed the end word
                        endWordID = spanIDNumber;
                    }
                    else
                    {
                        startWordID = spanIDNumber;
                    }
                }
                
                lastHoverdWordID = spanIDNumber;
                
                if(Number(startWordID)>Number(endWordID))
                {
                    startWordID = Number(startWordID)+Number(endWordID);
                    endWordID = Number(startWordID)-Number(endWordID);
                    startWordID = Number(startWordID) - Number(endWordID);
                }
                
                $('span').css('background-color','rgba(0, 0, 0, 0)');
                highlightText(startWordID,endWordID);
                drawSavedHighlights();
            }
        }
    }
};

function highlightText(sWordID,eWordID)
{
    selectedText = '';
    for(var i=Number(startWordID);i<=Number(endWordID);i++)
    {
        var spanIdToHighlight = 'wordID-'+i;
        $('#'+spanIdToHighlight).css('background-color','rgba(0,0,255,0.3)');
        selectedText = selectedText+$('#'+spanIdToHighlight).text();
    }
}

function setHighlightsData(jsonData)
{
    NSLog('here 11');
    NSLog('from core data : '+jsonData);
//    highlightVosJSONObj = JSON.parse(jsonData);
//    NSLog('from core data : '+highlightVosJSONObj[0].startWordID);
//    drawSavedHighlights();
}

function drawSavedHighlights()
{
    for(j in highlightVosJSONObj)
    {
        for(var i=Number(highlightVosJSONObj[j].startWordID);i<=Number(highlightVosJSONObj[j].endWordID);i++)
        {
            var spanIdToHighlight = 'wordID-'+i;
            $('#'+spanIdToHighlight).css('background-color','rgba(0,0,255,0.3)');
            selectedText = selectedText+$('#'+spanIdToHighlight).text();
        }
    }
}

function clearHighlightsArray()
{
    highlightVosJSONObj = [];
}

function addHightlight(startWID,endWID)
{
    var currHighlightVO = {};
    
    currHighlightVO['startWordID'] = startWID;
    currHighlightVO['endWordID'] = endWID;
    
    highlightVosJSONObj.push(currHighlightVO);
}



