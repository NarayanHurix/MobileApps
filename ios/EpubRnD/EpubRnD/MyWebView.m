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
    [self stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self includeJSObjCUtilsJS];
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
    
    NSString *fromJSToObjc = @"{\"MethodName\":\"wrappingWordsToSpans\",\"MethodArguments\":{\"arg1\":\"John\",\"arg2\":\"Doe\"}}";
    
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
                                            "callNativeMethod('%@%@')"
                                        "});"
                                    "}"
                                  "} ; addJquery();",jqueryLibPath.absoluteString,jsToObjcSchema,fromJSToObjc];
    [self stringByEvaluatingJavaScriptFromString:offlineJqueryLib];
}
- (void) wrappingWordsToSpans
{
    NSURL *jqueryLibPath =[[NSBundle mainBundle] URLForResource:@"wrap.spans.to.words" withExtension:@"js" subdirectory:@"/JSLibraries" ];
    NSString *fromJSToObjc = @"{\"MethodName\":\"didWrappingWordsToSpans\",\"MethodArguments\":{\"arg1\":\"John\",\"arg2\":\"Doe\"}}";
    
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
                                        "callNativeMethod('%@%@')"
                                  "});"
                                  "} ; includeJSFile();",jqueryLibPath.absoluteString,jsToObjcSchema,fromJSToObjc];
    [self stringByEvaluatingJavaScriptFromString:includeJSFile];
}

- (void) includeJSObjCUtilsJS
{
    NSURL *jqueryLibPath =[[NSBundle mainBundle] URLForResource:@"js.objc.utils" withExtension:@"js" subdirectory:@"/JSLibraries" ];
    
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
                               "});"
                               "} ; includeJSFile();",jqueryLibPath.absoluteString];
    [self stringByEvaluatingJavaScriptFromString:includeJSFile];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(request.URL.absoluteString.length>jsToObjcSchema.length)
    {
        NSString *schema = [request.URL.absoluteString substringToIndex:jsToObjcSchema.length];
        
        if([schema caseInsensitiveCompare:jsToObjcSchema]== NSOrderedSame)
        {
            NSURL *url =request.URL;
            
            NSString *jsonData = [url.absoluteString stringByReplacingOccurrencesOfString:jsToObjcSchema withString:@""];
            jsonData = [jsonData stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if(jsonData != nil)
            {
                NSError *error ;
                
                NSDictionary *dataFromJS = [NSJSONSerialization JSONObjectWithData:[jsonData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
                if(dataFromJS != nil)
                {
                    
                    [self callNativeMethodFromJS:dataFromJS];
                }
            }
            return NO;
        }
    }
    return YES;
}

- (void) callNativeMethodFromJS:(NSDictionary *) dataFromJS
{
    NSString *methodName = [dataFromJS objectForKey:@"MethodName"];
    NSDictionary *methodArgs = [dataFromJS objectForKey:@"MethodArguments"];
    if([methodName isEqualToString:@"wrappingWordsToSpans"])
    {
        [self wrappingWordsToSpans];
    }
    else if([methodName isEqualToString:@"didWrappingWordsToSpans"])
    {
        [self didWrappingWordsToSpans];
    }
    else if([methodName isEqualToString:@"NSLog"])
    {
        NSString *logMsg =[methodArgs objectForKey:@"arg1"];
        NSLog(@"From JS : %@",logMsg);
    }
    else if([methodName isEqualToString:@"saveTextHighlight"])
    {
        NSString *startWordId =[methodArgs objectForKey:@"arg1"];
        NSString *endWordId =[methodArgs objectForKey:@"arg2"];
        NSString *text =[methodArgs objectForKey:@"arg3"];
        [self saveTextHighlight:startWordId :endWordId highlightedText:text];
    }
}

- (void) didWrappingWordsToSpans
{
    
}
    
- (void) saveTextHighlight:(NSString *) startWordId :(NSString *) endWordID highlightedText:(NSString *) text
{
    NSLog(@"saving text highlight sID: %@  eID: %@  text: %@",startWordId,endWordID,text);
}

- (void) didHighlightButtonTap
{
    NSString *switchDocTouch = @"";
    if(HIGHLIGHT_TOOL_SWITCH)
    {
        switchDocTouch = @"bindDocumentTouch()";
    }
    else
    {
        switchDocTouch = @"unbindDocumentTouch()";
    }
    [self stringByEvaluatingJavaScriptFromString:switchDocTouch];
    
    NSString *setJSValues = [NSString stringWithFormat:@"setCurrentPageIndex(%d); setCurrentPageWidth(%f);",[self.webViewDAO getIndexOfPage],self.frame.size.width];
    [self stringByEvaluatingJavaScriptFromString:setJSValues];
    
}

@end
