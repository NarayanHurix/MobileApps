//
//  MyWebView.m
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "MyWebView.h"
#import "GlobalSettings.h"

@implementation MyWebView
{
    NSString *jsToObjcSchema;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // Initialization code
        jsToObjcSchema = @"jstoobjc:";
        self.delegate = self;
        self.scrollView.scrollEnabled = NO;
        self.scrollView.bounces = NO;
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) loadViewWithData:(WebViewDAO *) data
{
    _webViewDAO = data;
    [_myDelegate myWebViewBeganLoading];
    [self performSelector:@selector(loadWebData) withObject:self afterDelay:0.0 ];

}

- (void) loadWebData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:_webViewDAO.chapterVO.chapterURL  ofType:@"xhtml" inDirectory:@"assets/cole-voyage-of-life-20120320/EPUB/xhtml"];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *urlRqst = [NSURLRequest requestWithURL:url];
    [self loadRequest:urlRqst];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self addJSLibrariesToHTML];
    [self updateFontSize];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void) updateFontSize
{
    [_myDelegate myWebViewBeganLoading];
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'", (long)CURRENT_FONT_SIZE];
        [self stringByEvaluatingJavaScriptFromString:jsString];
        [self setPagination:self];
        
        NSString *callJSMethod = @"onJqueryLoadedMethod();";
        NSString *string = [self stringByEvaluatingJavaScriptFromString:callJSMethod];
        NSLog(@"%@",string);
    });
    
}

- (void) setPagination:(UIWebView *) webView
{
    
    
    NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
    
    NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
    "ruleIndex = mySheet.cssRules.length;"
    "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
    "}";
    
    NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;margin-top:10px;')", webView.frame.size.height-100, webView.frame.size.width];
    NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
    //NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", currentTextSize];
    
    
    [webView stringByEvaluatingJavaScriptFromString:varMySheet];
    
    [webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
    [webView stringByEvaluatingJavaScriptFromString:insertRule1];
    
    [webView stringByEvaluatingJavaScriptFromString:insertRule2];
    
    CGSize contentSize = CGSizeMake([[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth;"] floatValue],
                                    [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue]);
    [self.webViewDAO setPageCount:contentSize.width/webView.frame.size.width];
    
    NSLog(@"content width : %f ,frame width : %f ,my page count : %f",contentSize.width,webView.frame.size.width,contentSize.width/webView.frame.size.width);
    CGPoint point = CGPointMake(0, 0);
    if([self checkIsPageIndexOutOfRange])
    {
        //after decreasing font size page will be left blank
        [self.webViewDAO setIndexOfPage:[self.webViewDAO getPageCount]];
        [_myDelegate myWebViewOnPageOutOfRange];
    }
    else
    {
        
        if([self.webViewDAO getIndexOfPage] ==-2)
        {
            //load last page of chapter
            [self.webViewDAO setIndexOfPage:[self.webViewDAO getPageCount]-1];
        }
        point = CGPointMake([self.webViewDAO getIndexOfPage]*webView.frame.size.width, 0);
        self.scrollView.contentOffset = point;
    }
    [_myDelegate myWebViewDidLoadFinish];
}

- (BOOL) checkIsPageIndexOutOfRange
{
    //page index out of range
        
    return [self.webViewDAO getIndexOfPage]>=[self.webViewDAO getPageCount];
}


- (void) setJSBridge
{
//    id win = [self ];
//    [win setValue:self forKey:@"MyWebView"];
}

- (void) addJSLibrariesToHTML
{
    
    //NSString *jqueryLibPath = @"file:///Users/udaysravank/Library/Application%20Support/iPhone%20Simulator/7.0.3/Applications/D3A810BC-2826-4793-8C29-F65EC6454FD5/kitaboojune3.app/JSLibraries/jquery.min.js";
    //NSString *jqueryLibPath = @"file://localhost/Users/udaysravank/Library/Application%20Support/iPhone%20Simulator/7.0.3/Applications/D3A810BC-2826-4793-8C29-F65EC6454FD5/kitaboojune3.app//JSLibraries/jquery-1.11.1.min.js

    //NSString *jqueryLibPath = @"http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js";
    
    NSURL *jqueryLibPath =[[NSBundle mainBundle] URLForResource:@"jquery.min" withExtension:@"js" subdirectory:@"/JSLibraries" ];
    
    NSString *offlineJqueryLib = [NSString stringWithFormat:@"function addJquery()"
                                  "{"
                                    "function loadScript(url, callback)"
                                    "{"
                                        "var script = document.createElement('script');"
                                        "script.type = 'text/javascript';"
                                        "script.onload = function () {"
                                            "callback();"
                                         "};"
                                        "script.src = url;"
                                        "(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(script);"
                                    "}"
                                    "if(window.jQuery===undefined)"
                                    "{"
                                        "loadScript('%@', function ()"
                                        "{"
                                            "var iframe = document.createElement('iframe');"
                                            "iframe.setAttribute('src', '%@wrappingWordsToSpans');"
                                            "document.documentElement.appendChild(iframe);"
                                            "iframe.parentNode.removeChild(iframe);"
                                            "iframe = null;"
                                        "});"
                                    "}"
                                  "} ; addJquery();",jqueryLibPath.absoluteString,jsToObjcSchema];
    [self stringByEvaluatingJavaScriptFromString:offlineJqueryLib];
}
- (void) wrappingWordsToSpans
{
    NSURL *jqueryLibPath =[[NSBundle mainBundle] URLForResource:@"wrap.spans.to.words" withExtension:@"js" subdirectory:@"/JSLibraries" ];
    
    NSString *includeJSFile = [NSString stringWithFormat:@"function includeJSFile()"
                                  "{"
                                  "function loadScript(url, callback)"
                                  "{"
                                  "var script = document.createElement('script');"
                                  "script.type = 'text/javascript';"
                                  "script.onload = function () {"
                                  "callback();"
                                  "};"
                                  "script.src = url;"
                                  "(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(script);"
                                  "}"
                                  "loadScript('%@', function ()"
                                  "{"
                                        "var iframe = document.createElement('iframe');"
                                        "iframe.setAttribute('src', '%@didWrappingWordsToSpans');"
                                        "document.documentElement.appendChild(iframe);"
                                        "iframe.parentNode.removeChild(iframe);"
                                        "iframe = null;"
                                  "});"
                                  "} ; includeJSFile();",jqueryLibPath.absoluteString,jsToObjcSchema];
    [self stringByEvaluatingJavaScriptFromString:includeJSFile];
}
- (void) wrappingWordsToSpansOLD
{
    NSString *looper = [NSString stringWithFormat:@""
                        "function looper($el) {"
                            "alert('inside looper ');"
                            "var counter = 0, blnValidNode = true, text = '';"
                            "if (isLooped($el)) return false;"
                            "(function loop($dom) {"
                                "if ($dom.get(0).tagName.toLowerCase() === 'a' && $dom.get(0).href !== '') {"
                                    "counter++;"
                                    "$dom.wrapInner('<span id=\"' + counter + '\"/>');"
                                "} else {"
                                    "$dom.contents().each(function() {"
                                        "blnValidNode = isValidNode($(this).parent());"
                                        "// Text"
                                        "if (this.nodeType === 3 && blnValidNode) {"
                                            "var arrText = $.trim($(this).text()) === '' ? $(this).text() : $(this).text().replace(/[\\r\\n]/ig, '<br/>'),"
                                            "arrText = arrText.replace(/\\s+/g,' ').split(' '),"
                                            "lenText = arrText.length,"
                                            "containSpace = false;"
                                            "if (arrText.length === 1 && $(this).parent().get(0).tagName.toLowerCase() === 'span') {"
                                                "counter++;"
                                                "$(this).parent().attr('id', 'p1-textid' + counter);"
                                            "} else {"
                                                "arrText.forEach(function(text, i) {"
                                                    "if (text.replace(/[\r\n]/g, '').length > 0) {"
                                                        "if (this.nodeType === 1) {"
                                                            "loop($(this));"
                                                        "} else {"
                                                            "counter++;"
                                                            "arrText[i] = '<span id=\"p1-textid' + counter + '\">' + ( containSpace ? ' ' : '' ) + arrText[i] + ( i < lenText - 1 ? ' ' : '' ) + '</span>';"
                                                        "}"
                                                        "containSpace = false;"
                                                    "} else if (text === '' && i === 0) {"
                                                        "containSpace = true;"
                                                    "}"
                                                "});"
                                            "}"
                                            "// Bug in Chrome"
                                            "// http://bugs.jquery.com/ticket/12505"
                                            "try {"
                                                "text = arrText.join('');"
                                                "$(this).replaceWith(text === '' ? ' ' : text);"
                                            "} catch(e) {"
                                                "if (e.code === 12) {"
                                                    "try {"
                                                        "text = arrText.join('');"
                                                        "$(this).replaceWith($('<span/>').html(text === '' ? ' ' : text));"
                                                    "} catch(e) {"
                                                        "console.log(e);"
                                                    "}"
                                                "}"
                                            "}"
                                        "} else if (this.nodeType === 1 && blnValidNode) {"
                                            "loop($(this));"
                                        "}"
                                    "});"
                                "}"
                            "})($el);"
                            "function isValidNode($node) {"
                                "var nodeName = $node.get(0).nodeName.toLowerCase(),"
                                "arrInValidTags = ['script', 'code', 'textarea', 'select'],"
                                "isTransformed = $node.css('transform') !== \"none\";"
                                "return arrInValidTags.indexOf(nodeName) === -1 && !isTransformed ? true : false;"
                            "}"
                        "}"
                        
                        ""];
    [self stringByEvaluatingJavaScriptFromString:looper];
    
    NSString *isLooped = [NSString stringWithFormat:@""
                          "function isLooped($el) {"
                                "alert('inside isLooped ');"
                              "return $($el[0].querySelectorAll('span')).filter(function() { return this.id.match(//p[0-9]+-textid[0-9]+//); }).length > 0;"
                          "}"
                          ""];
    [self stringByEvaluatingJavaScriptFromString:isLooped];
    
    NSString *startPoint = [NSString stringWithFormat:@""
                                "$(function() {"
                                    "looper($('body'));"
                                "});"
                            ""];
    [self stringByEvaluatingJavaScriptFromString:startPoint];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(request.URL.absoluteString.length>jsToObjcSchema.length)
    {
        NSString *schema = [request.URL.absoluteString substringToIndex:jsToObjcSchema.length];
        NSLog(@"url : %@ cond : %d",schema,[schema caseInsensitiveCompare:jsToObjcSchema]== NSOrderedSame);
        if([schema caseInsensitiveCompare:jsToObjcSchema]== NSOrderedSame)
        {
            NSString *methodName = [request.URL.absoluteString stringByReplacingOccurrencesOfString:jsToObjcSchema withString:@""];
            [self callNativeMethodFromJS:methodName];
            return NO;
        }
    }
    return YES;
}

- (void) callNativeMethodFromJS:(NSString *) methodName
{
    if([methodName isEqualToString:@"wrappingWordsToSpans"])
    {
        [self wrappingWordsToSpans];
    }
    else if([methodName isEqualToString:@"didWrappingWordsToSpans"])
    {
        [self didWrappingWordsToSpans];
    }
}

- (void) didWrappingWordsToSpans
{
    [self applyCSSToSpans];
}
- (void) applyCSSToSpans
{
    NSString *applyCss = @"if(window.jQuery!==undefined)"
                        "{"
                            "$('span').css('background-color','green');"
                        "}";
    [self stringByEvaluatingJavaScriptFromString:applyCss];
}

@end
