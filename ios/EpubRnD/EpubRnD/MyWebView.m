//
//  MyWebView.m
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "MyWebView.h"
#import "GlobalSettings.h"
#import "HighlightPopupViewController.h"

@implementation MyWebView
{
    NSString *jsToObjcSchema;
    
    int stickHeight ,stickWidth;
}
@synthesize startStick,endStick;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // Initialization code
        jsToObjcSchema = @"jstoobjc:";
        self.delegate = self;
        self.scrollView.scrollEnabled = NO;
        self.scrollView.bounces = NO;
        stickHeight = 40;
        stickWidth =20;
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
    else if([methodName isEqualToString:@"updateHighlightSticksPositions"])
    {
        NSString *arg1 =[methodArgs objectForKey:@"arg1"];
        NSString *arg2 =[methodArgs objectForKey:@"arg2"];
        NSString *arg3 =[methodArgs objectForKey:@"arg3"];
        NSString *arg4 =[methodArgs objectForKey:@"arg4"];
        NSString *arg5 =[methodArgs objectForKey:@"arg5"];
        NSString *arg6 =[methodArgs objectForKey:@"arg6"];
        NSString *arg7 =[methodArgs objectForKey:@"arg7"];
        NSString *arg8 =[methodArgs objectForKey:@"arg8"];
        
        int sX =  [arg1 intValue];
        int sY =  [arg2 intValue];
        int sW =  [arg3 intValue];
        int sH =  [arg4 intValue];
        
        int eX =  [arg5 intValue];
        int eY =  [arg6 intValue];
        int eW =  [arg7 intValue];
        int eH =  [arg8 intValue];
        
        [self updateHighlightSticksPositions:sX :sY :sW :sH :eX : eY :eW :eH];
    }
    else if([methodName isEqualToString:@"onTouchStart"])
    {
        
    }
    else if([methodName isEqualToString:@"onTouchEnd"])
    {
        [self stringByEvaluatingJavaScriptFromString:@"setTouchedStick(false,true)"];
        if(startStick)
        {
            [self showHighlightContextMenu:startStick];
        }
    }
}

- (void) didWrappingWordsToSpans
{
    [self getAllHighlights];
}

- (NSManagedObjectContext *) managedObjectContext
{
    NSManagedObjectContext *context = Nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (void) saveHighlight
{
    [self stringByEvaluatingJavaScriptFromString:@"saveHighlight()"];
    if(startStick)
    {
        [startStick removeFromSuperview];
        startStick = nil;
    }
    
    if(endStick)
    {
        [endStick removeFromSuperview];
        endStick = nil;
    }
    if(highlightPopup)
    {
        [highlightPopup dismissPopoverAnimated:NO];
    }
}

- (void) saveTextHighlight:(NSString *) startWordId :(NSString *) endWordID highlightedText:(NSString *) text
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *oneRecord = [NSEntityDescription insertNewObjectForEntityForName:@"Highlights" inManagedObjectContext:context];
    [oneRecord setValue:startWordId forKey:@"startWordID"];
    [oneRecord setValue:endWordID forKey:@"endWordID"];
    //NSNumber *cIndex = [NSNumber numberWithInteger:[self.webViewDAO getIndexOfChapter]];
    NSString *chIn =[NSString stringWithFormat:@"%d",[self.webViewDAO getIndexOfChapter]] ;
    [oneRecord setValue:chIn forKey:@"chapterIndex"];
    [oneRecord setValue:text forKey:@"highlightedText"];
    NSError *error;
    
    if(![context save:&error])
    {
        NSLog(@"save highlight to sqlite failed with error : %@",[error localizedDescription]);
    }
    
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
        if(startStick)
        {
            [startStick removeFromSuperview];
            startStick = nil;
        }
        
        if(endStick)
        {
            [endStick removeFromSuperview];
            endStick = nil;
        }
    }
    [self stringByEvaluatingJavaScriptFromString:switchDocTouch];
    
    NSString *setJSValues = [NSString stringWithFormat:@"setCurrentPageIndex(%d); setCurrentPageWidth(%f);",[self.webViewDAO getIndexOfPage],self.frame.size.width];
    [self stringByEvaluatingJavaScriptFromString:setJSValues];
    
}

-(void) getAllHighlights
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Highlights" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSMutableArray *jsonArray = [[NSMutableArray alloc] init];
    NSPredicate *onlyForThisChapter = [NSPredicate predicateWithFormat:@"chapterIndex = %d", [self.webViewDAO getIndexOfChapter]];
    fetchRequest.predicate = onlyForThisChapter;
    
    NSArray *fetchedRecords = [context executeFetchRequest:fetchRequest error:&error];
    if(!error)
    {
        [self stringByEvaluatingJavaScriptFromString:@"clearHighlightsArray()"];
        for(NSManagedObject *record in fetchedRecords)
        {
            NSMutableDictionary *highlight = [[NSMutableDictionary alloc] init];
            [highlight setObject:[record valueForKey:@"startWordID"] forKey:@"startWordID"];
            [highlight setObject:[record valueForKey:@"endWordID"] forKey:@"endWordID"];
            //        [highlight setObject:[record valueForKey:@"chapterIndex"] forKey:@"chapterIndex"];
            //        [highlight setObject:[record valueForKey:@"highlightedText"] forKey:@"highlightedText"];
            NSString *sWID =[record valueForKey:@"startWordID"];
            NSString *eWID =[record valueForKey:@"endWordID"];
            [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"addHightlight('%@','%@')",sWID,eWID]];
            [jsonArray addObject:highlight];
        }
        [self stringByEvaluatingJavaScriptFromString:@"drawSavedHighlights()"];
    }
    
//    NSError *jsonError;
//    NSArray *temp = [NSArray arrayWithArray:jsonArray];
//    NSData *data = [NSJSONSerialization dataWithJSONObject:temp options:kNilOptions error:&jsonError];
//    if(jsonError)
//    {
//        NSLog(@"json error : %@",[jsonError localizedDescription]);
//    }
//    
//    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    NSString *send = [NSString stringWithFormat:@"setHighlightsData('%@')",jsonString];
//    
//    
//    [self stringByEvaluatingJavaScriptFromString:send];
    
}


- (void) updateHighlightSticksPositions:(int) sX  :(int) sY  :(int) sW :(int) sH :(int) eX  :(int) eY :(int) eW :(int) eH
{
    stickHeight = sH;
    
    if(!startStick)
    {
        int modifiedX = sX-stickWidth - (self.frame.size.width*[self.webViewDAO getIndexOfPage]);
        int modifiedY = sY-stickHeight/2;
        CGRect sRect = CGRectMake(modifiedX, modifiedY, stickWidth, stickHeight);
        startStick = [[StartStickView alloc] initWithFrame:sRect];
        startStick.myWebView = self;
        [startStick setBackgroundColor:[UIColor redColor]];
        [[self superview] addSubview:startStick];
    }
    else
    {
        int modifiedX = sX-stickWidth - (self.frame.size.width*[self.webViewDAO getIndexOfPage]);
        int modifiedY = sY-stickHeight/2;
        CGRect sRect = CGRectMake(modifiedX, modifiedY, stickWidth, stickHeight);
        startStick.frame = sRect;
    }
    stickHeight = eH;
    if(!endStick)
    {
        int modifiedX = eX - (self.frame.size.width*[self.webViewDAO getIndexOfPage]);
        int modifiedY = eY-stickHeight/2;
        CGRect eRect = CGRectMake(modifiedX, modifiedY, stickWidth, stickHeight);
        endStick = [[EndStickView alloc] initWithFrame:eRect];
        endStick.myWebView = self;
        [endStick setBackgroundColor:[UIColor greenColor]];
        [[self superview] addSubview:endStick];
    }
    else
    {
        int modifiedX = eX - (self.frame.size.width*[self.webViewDAO getIndexOfPage]);
        int modifiedY = eY-stickHeight/2;
        CGRect eRect = CGRectMake(modifiedX, modifiedY, stickWidth, stickHeight);
        endStick.frame = eRect;
    }
}
UIPopoverController *highlightPopup;
-(void) showHighlightContextMenu:(UIView *) anchorView
{
    CGRect rect = CGRectMake(anchorView.frame.size.width/2, 0, 0, 0);
    if(!highlightPopup)
    {
        HighlightPopupViewController *hContr = [[HighlightPopupViewController alloc ] init];
        highlightPopup= [[UIPopoverController alloc] initWithContentViewController:hContr];
        CGSize popoverContentSize = CGSizeMake(180, 60);
        highlightPopup.popoverContentSize =popoverContentSize;
        [highlightPopup setDelegate:self];
        hContr.myWebView = self;
        highlightPopup.passthroughViews = [NSArray arrayWithObjects:startStick,endStick,self, nil];
        
    }
    [highlightPopup presentPopoverFromRect:rect inView:anchorView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if(startStick)
    {
        [startStick removeFromSuperview];
        startStick = nil;
    }
    
    if(endStick)
    {
        [endStick removeFromSuperview];
        endStick = nil;
    }
    
    [self stringByEvaluatingJavaScriptFromString:@"setTouchedStick(false,true)"];
}

- (void) didTouchOnHighlightStick :(BOOL) isStartStick : (BOOL) isEndStick
{
    if(isStartStick)
    {
        [self stringByEvaluatingJavaScriptFromString:@"setTouchedStick(true,false)"];
        if(highlightPopup)
        {
            [highlightPopup dismissPopoverAnimated:NO];
        }
    }
    else
    {
        [self stringByEvaluatingJavaScriptFromString:@"setTouchedStick(false,true)"];
        if(highlightPopup)
        {
            [highlightPopup dismissPopoverAnimated:NO];
        }
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"json error : touchesBegan");
}

@end
