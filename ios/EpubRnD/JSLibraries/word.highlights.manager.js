var highlightVOColl = [];
var touchendStartStick = false ,touchendEndStick = false;

var currHVO = null;
var firstWordId = -1;
var lastWordId = -1;

function HighlightVO()
{
    var uniqueID;
    var startWordID;
    var endWordID;
    var sX;
    var sY;
    var sW;
    var sH;
    var eX;
    var eY;
    var eW;
    var eH;
    var selectedText;
    var hasNote;
};

function bindDocumentTouch()
{
    $(document).bind('touchstart',onTouchStart);
    
    $(document).bind('touchend',onTouchEnd);
    
    $(document).bind('touchmove',onTouchMove);
    touchendEndStick = true;
    touchendStartStick = false;
    NSLog('bind successfull');
}

function unbindDocumentTouch()
{
    $(document).unbind('touchstart');
    $(document).unbind('touchmove');
    $(document).unbind('touchend');
    touchendEndStick = false;
    touchendStartStick = false;
    NSLog('unbind successfull');
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

function triggerHighlight(pageX,pageY)
{
    var spanIDNumber;
    var obj = document.elementFromPoint(pageX-window.pageXOffset,pageY-window.pageYOffset);
    if($(obj).is('span'))
    {
        spanIDNumber = obj.id.split('-')[1];
    }
    if(spanIDNumber != undefined)
    {
        var jsCall1 = '{"MethodName":"onTouchStart","MethodArguments":{}}';
        callNativeMethod('jstoobjc:'+jsCall1);
        
        //initiate highlight vo
        currHVO = new HighlightVO();
        currHVO.startWordID =spanIDNumber;
        currHVO.endWordID =spanIDNumber;
        lastHoverdWordID = spanIDNumber;
        
        $('span').css('background-color','rgba(0, 0, 0, 0)');
        updateHighlightSticksPositions(currHVO.startWordID,currHVO.endWordID);
        highlightText(currHVO.startWordID,currHVO.endWordID);
        drawSavedHighlights();
        var jsCall2 = '{"MethodName":"onTouchEnd","MethodArguments":{}}';
        callNativeMethod('jstoobjc:'+jsCall2);noWordFoundToHighlightOnLongPress
    }
    else
    {
        var jsCall2 = '{"MethodName":"noWordFoundToHighlightOnLongPress","MethodArguments":{}}';
        callNativeMethod('jstoobjc:'+jsCall2);
    }
}

function onTouchStart(e)
{
    var jsonSaveHighlight = '{"MethodName":"onTouchStart","MethodArguments":{}}';
    callNativeMethod('jstoobjc:'+jsonSaveHighlight);
    
    if(touchendStartStick == true || touchendEndStick == true)
    {
        e.preventDefault();
        var spanIDNumber;
        var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
        var obj = document.elementFromPoint(touch.pageX-window.pageXOffset,touch.pageY-window.pageYOffset);
        if($(obj).is('span'))
        {
            spanIDNumber = obj.id.split('-')[1];
        }
        if(spanIDNumber != undefined)
        {
            if(currHVO == null || currHVO == undefined)
            {
                //initiate highlight vo
                currHVO = new HighlightVO();
                //check for existed highlight
                var seletedHVO = checkIsIntersectingWithExistedHighlights(spanIDNumber);
                if(seletedHVO)
                {
                    currHVO = seletedHVO;
                    $('span').css('background-color','rgba(0, 0, 0, 0)');
                    updateHighlightSticksPositions(currHVO.startWordID,currHVO.endWordID);
                    highlightText(currHVO.startWordID,currHVO.endWordID);
                    drawSavedHighlights();
                }
                else
                {
                    currHVO.startWordID =spanIDNumber;
                    currHVO.endWordID =spanIDNumber;
                }
            }
            else
            {
                //update current highlight vo
                var diff =Number(currHVO.endWordID)-Number(currHVO.startWordID);
                var centerWID = Number(Number(currHVO.startWordID)+(Number(diff)/2));
                
                if(Number(spanIDNumber)<=Number(centerWID))
                {
                    currHVO.startWordID = spanIDNumber;
                    lastHoverdWordID = spanIDNumber;
                }
                else
                {
                    currHVO.endWordID = spanIDNumber;
                    lastHoverdWordID = spanIDNumber;
                }
                
            }
            
        }
    }
};

var lastHoverdWordID = -1;
function onTouchMove(e)
{
    e.preventDefault();
    if((touchendStartStick == true || touchendEndStick == true) && currHVO != undefined)
    {
        var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
        var obj = document.elementFromPoint(touch.pageX-window.pageXOffset,touch.pageY-window.pageYOffset);
        
        if($(obj).is('span'))
        {
            var spanIDNumber = obj.id.split('-')[1];
            if(lastHoverdWordID != spanIDNumber)
            {
                if(Number(lastHoverdWordID)>Number(spanIDNumber))
                {
                    //moving backward
                    if(Number(spanIDNumber)<Number(currHVO.startWordID))
                    {
                        //crossed start word
                        currHVO.startWordID = spanIDNumber;
                    }
                    else
                    {
                        currHVO.endWordID = spanIDNumber;
                    }
                }
                else
                {
                    //moving forward
                    if(Number(spanIDNumber)>Number(currHVO.endWordID))
                    {
                        //crossed the end word
                        currHVO.endWordID = spanIDNumber;
                    }
                    else
                    {
                        currHVO.startWordID = spanIDNumber;
                    }
                }
                
                lastHoverdWordID = spanIDNumber;
                
                if(Number(currHVO.startWordID)>Number(currHVO.endWordID))
                {
                    currHVO.startWordID = Number(currHVO.startWordID)+Number(currHVO.endWordID);
                    currHVO.endWordID = Number(currHVO.startWordID)-Number(currHVO.endWordID);
                    currHVO.startWordID = Number(currHVO.startWordID) - Number(currHVO.endWordID);
                }
                
                $('span').css('background-color','rgba(0, 0, 0, 0)');
                updateHighlightSticksPositions(currHVO.startWordID,currHVO.endWordID);
                highlightText(currHVO.startWordID,currHVO.endWordID);
                drawSavedHighlights();
            }
        }
    }
};

function onTouchEnd(e)
{
    var jsonSaveHighlight = '{"MethodName":"onTouchEnd","MethodArguments":{}}';
    callNativeMethod('jstoobjc:'+jsonSaveHighlight);
    e.preventDefault();
    if(touchendStartStick == true || touchendEndStick == true)
    {
        var touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
        var obj = document.elementFromPoint(touch.pageX-window.pageXOffset,touch.pageY-window.pageYOffset);
        if($(obj).is('span'))
        {
            var spanIDNumber = obj.id.split('-')[1];
            //currHVO.endWordID =spanIDNumber;
        }
        //saveHighlight();
        
        drawSavedHighlights();
    }
};


function checkIsIntersectingWithExistedHighlights(wordID)
{
    var seletedHVO = null;
    for(j in highlightVOColl)
    {
        if(Number(wordID)==Number(highlightVOColl[j].startWordID) || Number(wordID) == Number(highlightVOColl[j].endWordID))
        {
            return highlightVOColl.pop(highlightVOColl[j]);
        }
        else if(Number(wordID)>Number(highlightVOColl[j].startWordID) &&  Number(wordID) < Number(highlightVOColl[j].endWordID))
        {
            return highlightVOColl.pop(highlightVOColl[j]);
        }
    }
    return null;
}


function saveCurrentHighlight(hasNote)
{
    if(currHVO != null || currHVO != undefined)
    {
        highlightText(currHVO.startWordID,currHVO.endWordID);
        
        var formattedText = JSON.stringify(getSelectedText(currHVO.startWordID,currHVO.endWordID));
        var jsonSaveHighlight = '{"MethodName":"saveTextHighlightToPersistantStorage","MethodArguments":{"arg1":"'+currHVO.startWordID+'","arg2":"'+currHVO.endWordID+'","arg3":'+formattedText+'}}';
        
        callNativeMethod('jstoobjc:'+jsonSaveHighlight);
        
//        var currHighlightVO = {};
//        
//        currHighlightVO['startWordID'] = currHVO.startWordID;
//        currHighlightVO['endWordID'] = currHVO.endWordID;
        
        var vo = new HighlightVO();
        vo.startWordID = currHVO.startWordID;
        vo.endWordID = currHVO.endWordID;
        vo.hasNote = hasNote;
        
        highlightVOColl.push(vo);
        currHVO = null;
    }
}

function clearCurrentHighlight()
{
    currHVO = null;
    lastHoverdWordID = -1;
    $('span').css('background-color','rgba(0, 0, 0, 0)');
    drawSavedHighlights();
}

function highlightText(sWordID,eWordID)
{
    for(var i=Number(sWordID);i<=Number(eWordID);i++)
    {
        var spanIdToHighlight = 'wordID-'+i;
        $('#'+spanIdToHighlight).css('background-color','rgba(0,0,255,0.3)');
    }
}

//unable to extract text with double quotes- need work around for this
function getSelectedText(sWordID,eWordID)
{
    var selectedText = '';
    for(var i=Number(sWordID);i<=Number(eWordID);i++)
    {
        var spanIdToHighlight = 'wordID-'+i;
//        NSLog('mad sheep 1 ');
//        NSLog($($('#'+spanIdToHighlight)).text());
        selectedText = selectedText+$($('#'+spanIdToHighlight)).text();
    }
    return selectedText;
}

function addNoteIconToPage(sWordID ,eWordID)
{
    var sID = 0;
    var sX = 0;
    var sY = 0;
    var sW = 0;
    var sH = 0;
    
    var eID = 0;
    var eX = 0;
    var eY = 0;
    var eW = 0;
    var eH = 0;
    
    sID = sWordID;
    sX = $('#wordID-'+sWordID).position().left;
    sY = $('#wordID-'+sWordID).position().top;
    sW = $('#wordID-'+sWordID).width();
    sH = $('#wordID-'+sWordID).height();
    
    eID = eWordID
    eX = $('#wordID-'+eWordID).position().left + $('#wordID-'+eWordID).width();
    eY = $('#wordID-'+eWordID).position().top + $('#wordID-'+eWordID).height();
    eW = $('#wordID-'+eWordID).width();
    eH = $('#wordID-'+eWordID).height();
    
    var text = getSelectedText(sWordID,eWordID);
    var formattedText = JSON.stringify(text);
    var jsonSaveHighlight = '{"MethodName":"addNoteIconToPage","MethodArguments":{"arg1":"'+sID+'","arg2":"'+sX+'","arg3":"'+sY+'","arg4":"'+sW+'","arg5":"'+sH+'","arg6":"'+eID+'","arg7":"'+eX+'","arg8":"'+eY+'","arg9":"'+eW+'","arg10":"'+eH+'","arg11":'+formattedText+'}}';
    
    callNativeMethod('jstoobjc:'+jsonSaveHighlight);
}

function updateHighlightSticksPositions(sWordID ,eWordID)
{
    var sID = 0;
    var sX = 0;
    var sY = 0;
    var sW = 0;
    var sH = 0;
    
    var eID = 0;
    var eX = 0;
    var eY = 0;
    var eW = 0;
    var eH = 0;
    
    sID = sWordID;
    sX = $('#wordID-'+sWordID).position().left;
    sY = $('#wordID-'+sWordID).position().top;
    sW = $('#wordID-'+sWordID).width();
    sH = $('#wordID-'+sWordID).height();
    
    eID = eWordID
    eX = $('#wordID-'+eWordID).position().left + $('#wordID-'+eWordID).width();
    eY = $('#wordID-'+eWordID).position().top + $('#wordID-'+eWordID).height();
    eW = $('#wordID-'+eWordID).width();
    eH = $('#wordID-'+eWordID).height();
    
    var jsonSaveHighlight = '{"MethodName":"updateHighlightSticksPositions","MethodArguments":{"arg1":"'+sID+'","arg2":"'+sX+'","arg3":"'+sY+'","arg4":"'+sW+'","arg5":"'+sH+'","arg6":"'+eID+'","arg7":"'+eX+'","arg8":"'+eY+'","arg9":"'+eW+'","arg10":"'+eH+'"}}';
    callNativeMethod('jstoobjc:'+jsonSaveHighlight);
}

function drawSavedHighlights()
{
    for(j in highlightVOColl)
    {
        var sid = Number(highlightVOColl[j].startWordID);
        var eid = Number(highlightVOColl[j].endWordID);
        
        for(var i=sid;i<=eid;i++)
        {
            var spanIdToHighlight = 'wordID-'+i;
            $('#'+spanIdToHighlight).css('background-color','rgba(0,0,255,0.3)');
        }
        if(highlightVOColl[j].hasNote)
        {
            addNoteIconToPage(highlightVOColl[j].startWordID ,highlightVOColl[j].endWordID);
        }
    }
}

function clearHighlightsArray()
{
    highlightVOColl = [];
}

function addHightlight(uniqueIdStr,startWID,endWID,hasNote)
{
    var currHighlightVO = new HighlightVO();
    currHighlightVO.uniqueID = uniqueIdStr;
    currHighlightVO.startWordID = startWID;
    currHighlightVO.endWordID = endWID;
    currHighlightVO.hasNote = hasNote;
    highlightVOColl.push(currHighlightVO);
}

function setTouchedStick(isStartStick,isEndStick)
{
    if(isStartStick == true)
    {
        touchendStartStick = true;
        touchendEndStick = false;
    }
    else if(isEndStick == true)
    {
        touchendStartStick = false;
        touchendEndStick = true;
    }
    else
    {
        touchendStartStick = false;
        touchendEndStick = false;
    }
}

function findFirstAndLastWordsOfPage(columnWidth,indexOfCurrPage,indexOfNextPage)
{
    //NSLog('Curr Page Index : '+indexOfCurrPage +' nextPageIndex :'+indexOfNextPage);
    firstWordId = -1;
    lastWordId = -1;
    var arrOfSpans =  $('span');
    if(arrOfSpans.length==0)
    {
        var callNatMethod = '{"MethodName":"didFindFirstAndLastWordsOfPage","MethodArguments":{"arg1":"'+Number(firstWordId)+'","arg2":"'+Number(lastWordId)+'"}}';
        callNativeMethod('jstoobjc:'+callNatMethod);
        return;
    }
    $.each(arrOfSpans,function(i,obj)
    {
       var spanID = obj.id;
       if(spanID != undefined)
       {
            var spanIDNumber = obj.id.split('-')[1];
            var leftMargin = $(obj).position().left;
            if(firstWordId == -1)
            {
                if(Number(indexOfCurrPage) == 0)
                {
                    firstWordId = spanIDNumber;
                }
                else if(Number(leftMargin)> (Number(columnWidth)*Number(indexOfCurrPage)))
                {
                    firstWordId = spanIDNumber;
                }

                if(firstWordId != -1)
                {
                   //NSLog('    firstWID: '+firstWordId);
//                   var fw = 'wordID-'+firstWordId;
//                   $('#'+fw).css('background-color','rgba(255,0,0,0.4)');
                }
            }
                        
            if(lastWordId == -1 && firstWordId != -1)
            {
                if(indexOfNextPage == -1 && firstWordId != -1)
                {
                   lastWordId = arrOfSpans[arrOfSpans.length-1].id.split('-')[1];
                }
                else if(Number(leftMargin)> (Number(columnWidth)*Number(indexOfNextPage)) && i!= 0)
                {
                    lastWordId = arrOfSpans[i-1].id.split('-')[1];
                }

                if(lastWordId != -1)
                {
                    //NSLog('    lastWID: '+lastWordId);
//                    var lw = 'wordID-'+lastWordId;
//                    $('#'+lw).css('background-color','rgba(0,255,0,0.4)');

                    var callNatMethod = '{"MethodName":"didFindFirstAndLastWordsOfPage","MethodArguments":{"arg1":"'+Number(firstWordId)+'","arg2":"'+Number(lastWordId)+'"}}';
                    callNativeMethod('jstoobjc:'+callNatMethod);
                    return;
                }
            }
       }
    });
}

function copySelectedTextToPasteBoard()
{
    if(currHVO != null || currHVO != undefined)
    {
        var text = getSelectedText(currHVO.startWordID,currHVO.endWordID);
        var formattedText = JSON.stringify(text);
        var callNatMethod = '{"MethodName":"copySelectedTextToPasteBoard","MethodArguments":{"arg1":'+formattedText+'}}';
        callNativeMethod('jstoobjc:'+callNatMethod);
    }
}

function bookmarkThisPage()
{
    var text = getSelectedText(firstWordId,Number(firstWordId)+4);
    var formattedText = JSON.stringify(text);
    var callNatMethod = '{"MethodName":"bookmarkThisPage","MethodArguments":{"arg1":'+formattedText+'}}';
    callNativeMethod('jstoobjc:'+callNatMethod);
}

function findIndexOfPageUsingWordId(columnWidth , wordID)
{
    var indexOfPage = -1;
    var spanID = 'wordID-'+wordID;
    var leftMargin = $('#'+spanID).position().left;
    var res = Number(leftMargin)/Number(columnWidth);
    indexOfPage = Math.ceil(res)-1;
    
    var callNatMethod = '{"MethodName":"didFindIndexOfPage","MethodArguments":{"arg1":"'+indexOfPage+'"}}';
    callNativeMethod('jstoobjc:'+callNatMethod);
}