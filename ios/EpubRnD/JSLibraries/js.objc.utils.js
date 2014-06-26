function callNativeMethod(jsonData)
{
    var iframe = document.createElement('iframe');
	iframe.setAttribute('src', ''+jsonData);
	document.documentElement.appendChild(iframe);
	iframe.parentNode.removeChild(iframe);
	iframe = null;
}

function NSLog(msg)
{
    var json = '{"MethodName":"NSLog","MethodArguments":{"arg1":"'+msg+'"}}';
    callNativeMethod('jstoobjc:'+json);
}