var highlightVOColl = [];
var touchendStartStick = false ,touchendEndStick = false;

var currHVO = null;

function HighlightVO()
{
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
};

function bindDocumentTouch()
{
    $(document).bind('touchstart',onTouchStart);
    
    $(document).bind('touchend',onTouchEnd);
    
    $(document).bind('touchmove',onTouchMove);
    touchendEndStick = true;
    touchendStartStick = false;
    jsInterface.log('bind successfull');
}

function unbindDocumentTouch()
{
    $(document).unbind('touchstart');
    $(document).unbind('touchmove');
    $(document).unbind('touchend');
    touchendEndStick = false;
    touchendStartStick = false;
    jsInterface.log('unbind successfull');
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
        jsInterface.callNativeMethod('jstoobjc:'+jsCall1);
        
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
        jsInterface.callNativeMethod('jstoobjc:'+jsCall2);
    }
}

function onTouchStart(e)
{
    var jsonSaveHighlight = '{"MethodName":"onTouchStart","MethodArguments":{}}';
    jsInterface.callNativeMethod('jstoobjc:'+jsonSaveHighlight);
    
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
    jsInterface.callNativeMethod('jstoobjc:'+jsonSaveHighlight);
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


function saveCurrentHighlight()
{
    if(currHVO != null || currHVO != undefined)
    {
        highlightText(currHVO.startWordID,currHVO.endWordID);
        var jsonSaveHighlight = '{"MethodName":"saveTextHighlight","MethodArguments":{"arg1":"'+currHVO.startWordID+'","arg2":"'+currHVO.endWordID+'","arg3":"'+currHVO.selectedText+'"}}';
        jsInterface.callNativeMethod('jstoobjc:'+jsonSaveHighlight);
        
//        var currHighlightVO = {};
//        
//        currHighlightVO['startWordID'] = currHVO.startWordID;
//        currHighlightVO['endWordID'] = currHVO.endWordID;
        
        var vo = new HighlightVO();
        vo.startWordID = currHVO.startWordID;
        vo.endWordID = currHVO.endWordID;
        
        
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

function getSelectedText(sWordID,eWordID)
{
    var selectedText = '';
    for(var i=Number(sWordID);i<=Number(eWordID);i++)
    {
        var spanIdToHighlight = 'wordID-'+i;
        selectedText = selectedText+$('#'+spanIdToHighlight).text();
    }
    return selectedText;
}

function updateHighlightSticksPositions(sWordID ,eWordID)
{
    var sX = 0;
    var sY = 0;
    var eX = 0;
    var eY = 0;
    
    sX = $('#wordID-'+sWordID).position().left;
    sY = $('#wordID-'+sWordID).position().top;
    sW = $('#wordID-'+sWordID).width();
    sH = $('#wordID-'+sWordID).height();
    
    eX = $('#wordID-'+eWordID).position().left + $('#wordID-'+eWordID).width();
    eY = $('#wordID-'+eWordID).position().top + $('#wordID-'+eWordID).height();
    eW = $('#wordID-'+eWordID).width();
    eH = $('#wordID-'+eWordID).height();
    
    
    var jsonSaveHighlight = '{"MethodName":"updateHighlightSticksPositions","MethodArguments":{"arg1":"'+sX+'","arg2":"'+sY+'","arg3":"'+sW+'","arg4":"'+sH+'","arg5":"'+eX+'","arg6":"'+eY+'","arg7":"'+eW+'","arg8":"'+eH+'"}}';
    jsInterface.callNativeMethod('jstoobjc:'+jsonSaveHighlight);
}

function drawSavedHighlights()
{
    for(j in highlightVOColl)
    {
        for(var i=Number(highlightVOColl[j].startWordID);i<=Number(highlightVOColl[j].endWordID);i++)
        {
            var spanIdToHighlight = 'wordID-'+i;
            $('#'+spanIdToHighlight).css('background-color','rgba(0,0,255,0.3)');
        }
    }
}

function clearHighlightsArray()
{
    highlightVOColl = [];
}

function addHightlight(startWID,endWID)
{
    var currHighlightVO = new HighlightVO();
    
    currHighlightVO.startWordID = startWID;
    currHighlightVO.endWordID = endWID;
    
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

