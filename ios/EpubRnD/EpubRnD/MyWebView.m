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
    BOOL SHOULD_DISMISS;
    BOOL isAddingNote;
    BOOL contentFit;
    float contentHeightBeforeFitPage,contentHeightAfterFitPage;
    float scaleFactorPageFit;
    HighlightPopupViewController *hContr;
    UIPopoverController *highlightPopup;
    
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
        
        contentFit = NO;
        
        contentHeightBeforeFitPage = 0.0f;
        contentHeightAfterFitPage = 0.0f;
        scaleFactorPageFit = 1.0f;
        
        stickHeight = 40;
        stickWidth =15;
        SHOULD_DISMISS = NO;
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
    startStick = [[StartStickView alloc] init];
    startStick.myWebView = self;
    startStick.hidden = YES;
    [[self superview] addSubview:startStick];
    
    endStick = [[EndStickView alloc] init];
    endStick.myWebView = self;
    endStick.hidden = YES;
    [[self superview] addSubview:endStick];
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:_webViewDAO.chapterVO.chapterURL  ofType:@"xhtml" inDirectory:CHAPTERS_FOLDER_PATH];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *urlRqst = [NSURLRequest requestWithURL:url];
    [self loadRequest:urlRqst];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    if(EPUB_LAYOUT_TYPE == FIXED && !contentFit)
    {
        self.scalesPageToFit = YES;
        contentHeightBeforeFitPage = webView.scrollView.contentSize.height;
        contentFit = YES;
        [self reload];
        return;
    }
    else
    {
        contentHeightAfterFitPage = webView.scrollView.contentSize.height;
        if(EPUB_LAYOUT_TYPE == FIXED)
        {
            scaleFactorPageFit = contentHeightAfterFitPage / contentHeightBeforeFitPage;
        }
    }
    
    
    [self stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self includeJSObjCUtilsJS];
    [self addJSLibrariesToHTML];
    [self updateFontSize];
}

- (float) getScaleFactorOfPageFit
{
    return scaleFactorPageFit;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void) updateFontSize
{
    if(EPUB_LAYOUT_TYPE == REFLOWABLE)
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
    else
    {
        [self.webViewDAO setPageCount:1];
        [_myDelegate myWebViewDidLoadFinish];
    }
}

- (void) setPagination:(UIWebView *) webView
{
    NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
    
    NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
    "ruleIndex = mySheet.cssRules.length;"
    "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
    "}";
    
    NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
    NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
    //NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", currentTextSize];
    
    [webView stringByEvaluatingJavaScriptFromString:varMySheet];
    
    [webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
    [webView stringByEvaluatingJavaScriptFromString:insertRule1];
    
    [webView stringByEvaluatingJavaScriptFromString:insertRule2];
    
    
    CGSize contentSize = CGSizeMake([[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth;"] floatValue],
                                    [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue]);
    [self.webViewDAO setPageCount:contentSize.width/webView.frame.size.width];
    
//    NSLog(@"content width : %f ,frame width : %f ,my page count : %f",contentSize.width,webView.frame.size.width,contentSize.width/webView.frame.size.width);
    CGPoint point = CGPointMake(0, 0);
    if([self checkIsPageIndexOutOfRange])
    {
        //after decreasing font size page will be left blank
        [self.webViewDAO setIndexOfPage:[self.webViewDAO getPageCount]-1];
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
    NSString *fromJSToObjc = @"{\"MethodName\":\"didWrappingWordsToSpans\",\"MethodArguments\":{}}";
    
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
                                  "if(document.getElementsByTagName('head')[0] || "
                                  "document.getElementsByTagName('body')[0])"
                                  "{ "
                                  "(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(script);"
                                  "}"
                                  "else{callback();}"
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

- (void) includeWordHighlightsManagerJS
{
    NSURL *jqueryLibPath =[[NSBundle mainBundle] URLForResource:@"word.highlights.manager" withExtension:@"js" subdirectory:@"/JSLibraries" ];
    NSString *fromJSToObjc = @"{\"MethodName\":\"didHighlightManagerJSadded\",\"MethodArguments\":{}}";
    
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
                               "if(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0])"
                               "{"
                               "(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(script);"
                               "}"
                               "else { callback(); }"
                               "}"
                               "loadScript('%@', function ()"
                               "{"
                               "callNativeMethod('%@%@')"
                               "});"
                               "} ; includeJSFile();",jqueryLibPath.absoluteString,jsToObjcSchema,fromJSToObjc];
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
    else if([methodName isEqualToString:@"didHighlightManagerJSadded"])
    {
        [self didHighlightManagerJSadded];
    }
    else if([methodName isEqualToString:@"didFindFirstAndLastWordsOfPage"])
    {
        NSString *arg1 =[methodArgs objectForKey:@"arg1"];
        NSString *arg2 =[methodArgs objectForKey:@"arg2"];
       [self didFindFirstAndLastWordsOfPage:[arg1 intValue] :[arg2 intValue]];
    }
    else if([methodName isEqualToString:@"NSLog"])
    {
        NSString *logMsg =[methodArgs objectForKey:@"arg1"];
        NSLog(@"From JS : %@",logMsg);
    }
    else if([methodName isEqualToString:@"saveTextHighlightToPersistantStorage"])
    {
//        NSString *startWordId =[methodArgs objectForKey:@"arg1"];
//        NSString *endWordId =[methodArgs objectForKey:@"arg2"];
        NSString *text =[methodArgs objectForKey:@"arg3"];
        [self saveTextHighlightToPersistantStorage:text];
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
        NSString *arg9 =[methodArgs objectForKey:@"arg9"];
        NSString *arg10 =[methodArgs objectForKey:@"arg10"];
        
        
        int sID = [arg1 intValue];
        int sX =  [arg2 intValue];
        int sY =  [arg3 intValue];
        int sW =  [arg4 intValue];
        int sH =  [arg5 intValue];
        
        int eID = [arg6 intValue];
        int eX =  [arg7 intValue];
        int eY =  [arg8 intValue];
        int eW =  [arg9 intValue];
        int eH =  [arg10 intValue];
        
        [self updateHighlightSticksPositions:sID :sX :sY :sW :sH :eID :eX : eY :eW :eH ];
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
    else if([methodName isEqualToString:@"addNoteIconToPage"])
    {
        NSString *arg1 =[methodArgs objectForKey:@"arg1"];
        NSString *arg2 =[methodArgs objectForKey:@"arg2"];
        NSString *arg3 =[methodArgs objectForKey:@"arg3"];
        NSString *arg4 =[methodArgs objectForKey:@"arg4"];
        NSString *arg5 =[methodArgs objectForKey:@"arg5"];
        NSString *arg6 =[methodArgs objectForKey:@"arg6"];
        NSString *arg7 =[methodArgs objectForKey:@"arg7"];
        NSString *arg8 =[methodArgs objectForKey:@"arg8"];
        NSString *arg9 =[methodArgs objectForKey:@"arg9"];
        NSString *arg10 =[methodArgs objectForKey:@"arg10"];
        NSString *arg11 =[methodArgs objectForKey:@"arg11"];
        NSString *arg12 =[methodArgs objectForKey:@"arg12"];
        
        int sID = [arg1 intValue];
        int sX =  [arg2 intValue];
        int sY =  [arg3 intValue];
        int sW =  [arg4 intValue];
        int sH =  [arg5 intValue];
        
        int eID = [arg6 intValue];
        int eX =  [arg7 intValue];
        int eY =  [arg8 intValue];
        int eW =  [arg9 intValue];
        int eH =  [arg10 intValue];
        
        BOOL hasNote = [arg12 boolValue];
        
        [self addNoteIconToPage:sID :sX :sY :sW :sH :eID :eX : eY :eW :eH :arg11 :hasNote];
    }
    else if([methodName isEqualToString:@"noWordFoundToHighlightOnLongPress"])
    {
        [_myDelegate toggleHighlightSwitch];
    }
    else if([methodName isEqualToString:@"copySelectedTextToPasteBoard"])
    {
        NSString *arg1 =[methodArgs objectForKey:@"arg1"];
        [self copySelectedTextToPasteBoard:arg1];
    }
    else if([methodName isEqualToString:@"bookmarkThisPage"])
    {
        NSString *arg1 =[methodArgs objectForKey:@"arg1"];
        [self bookmarkThisPage:arg1];
    }
    
    
}

- (void) didWrappingWordsToSpans
{
    [self includeWordHighlightsManagerJS];
}

- (void) didHighlightManagerJSadded
{
    int indexOfNextPage = -1;
    if([self.webViewDAO getIndexOfPage]<[self.webViewDAO getPageCount]-1)
    {
        indexOfNextPage = [self.webViewDAO getIndexOfPage]+1;
    }
    NSString *str = [NSString stringWithFormat:@"findFirstAndLastWordsOfPage(%f,%d,%d)",self.frame.size.width,[self.webViewDAO getIndexOfPage],indexOfNextPage];
    [self stringByEvaluatingJavaScriptFromString:str];
}

- (void) didFindFirstAndLastWordsOfPage:(int) firstWordIdInCurrPage :(int) lastWordIdInCurrPage
{
    [self.webViewDAO setFirstWordID:firstWordIdInCurrPage];
    [self.webViewDAO setLastWordID:lastWordIdInCurrPage];
    [self getAllHighlights];
    [self getAllBookmarksOfThisChapter];
    NSLog(@"cIndex : %d  pageIndex : %d  firstWordID : %d",[self.webViewDAO getIndexOfChapter], [self.webViewDAO getIndexOfPage], firstWordIdInCurrPage);
    if(firstWordIdInCurrPage ==-1 )
    {
        [self.myDelegate disableBookmark:YES];
    }
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
    [self stringByEvaluatingJavaScriptFromString:@"saveCurrentHighlight()"];
    if(startStick)
    {
        //[startStick removeFromSuperview];
        startStick.hidden = YES;
    }
    
    if(endStick)
    {
        //[endStick removeFromSuperview];
        endStick.hidden = YES;
    }
    if(highlightPopup)
    {
        SHOULD_DISMISS = YES;
        [highlightPopup dismissPopoverAnimated:NO];
    }
    if(HIGHLIGHT_TOOL_SWITCH)
    {
        [_myDelegate toggleHighlightSwitch];
    }
    
    if(!isAddingNote)
    {
        self.currHighlightVO = nil;
    }
}

- (void) closePopupAndClearHighlight
{
    [self stringByEvaluatingJavaScriptFromString:@"clearCurrentHighlight()"];
    if(startStick)
    {
        //[startStick removeFromSuperview];
        startStick.hidden = YES;
    }
    
    if(endStick)
    {
        //[endStick removeFromSuperview];
        endStick.hidden = YES;
    }
    if(highlightPopup)
    {
        SHOULD_DISMISS = YES;
        [highlightPopup dismissPopoverAnimated:NO];
    }
    if(HIGHLIGHT_TOOL_SWITCH)
    {
        [_myDelegate toggleHighlightSwitch];
    }
    self.currHighlightVO = Nil;
}

- (void) saveTextHighlightToPersistantStorage:(NSString *) selectedText
{
    if(self.currHighlightVO)
    {
        self.currHighlightVO.selectedText = selectedText;
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSManagedObject *oneRecord = [NSEntityDescription insertNewObjectForEntityForName:@"Highlights" inManagedObjectContext:context];
        [oneRecord setValue:[NSNumber numberWithInt:[self.currHighlightVO getStartWordID]]  forKey:@"startWordID"];
        [oneRecord setValue:[NSNumber numberWithInt:[self.currHighlightVO getEndWordID]] forKey:@"endWordID"];
        [oneRecord setValue:[NSNumber numberWithInteger:[self.webViewDAO getIndexOfChapter]] forKey:@"chapterIndex"];
        [oneRecord setValue:self.currHighlightVO.selectedText forKey:@"highlightedText"];
        [oneRecord setValue:[NSNumber numberWithBool:isAddingNote] forKey:@"hasNote"];
        
        
        
        NSError *error;
        
        if(![context save:&error])
        {
            NSLog(@"save highlight to sqlite failed with error : %@",[error localizedDescription]);
        }
        else
        {
            //NSManagedObjectID *uniqueID = [oneRecord objectID];
            
            if(isAddingNote)
            {
                NSString *jsMethod = [NSString stringWithFormat:@"addNoteIconToPage(%d,%d,'%@')",[self.currHighlightVO getStartWordID],[self.currHighlightVO getEndWordID],isAddingNote? @"true" : @"false"];
                [self stringByEvaluatingJavaScriptFromString:jsMethod];
            }
            NSLog(@"saving text highlight sID: %d  eID: %d  text: %@",[self.currHighlightVO getStartWordID],[self.currHighlightVO getEndWordID],self.currHighlightVO.selectedText);
        }
    }
}

- (void) addNoteIconToPage:(int) sID :(int) sX  :(int) sY  :(int) sW :(int) sH :(int) eID :(int)eX  :(int) eY :(int) eW :(int) eH :(NSString *) text :(BOOL) hasNote
{
    if(sID>=[self.webViewDAO getFirstWordID] && sID<=[self.webViewDAO getLastWordID])
    {
        HighlightVO  *hVO = [HighlightVO new];
        
        [hVO setChapterPath:self.webViewDAO.chapterVO.chapterURL];
        [hVO setChapterIndex:[self.webViewDAO getIndexOfChapter]];
        [hVO setStartWordID:sID];
        [hVO setEndWordID:eID];
        [hVO setNoOfPagesInChapter:self.webViewDAO.chapterVO.pageCountInChapter];
        [hVO setSelectedText:text];
        
        if(hVO && hasNote)
        {
            StickyNoteView *noteView = [[StickyNoteView alloc] init];
            noteView.myDelegate = self;
            noteView.highlightVO = hVO ;
            
            //int modifiedX = sX-(self.frame.size.width*[self.webViewDAO getIndexOfPage]);
            noteView.frame = CGRectMake(20, sY, STICKY_NOTE_ICON_WIDTH , STICKY_NOTE_ICON_HEIGHT);
            [[self superview] addSubview:noteView];
            [[self superview] bringSubviewToFront:noteView];
        }
    }
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
            //[startStick removeFromSuperview];
            startStick.hidden = YES;
        }
        
        if(endStick)
        {
            //[endStick removeFromSuperview];
            endStick.hidden = YES;
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
            NSNumber *hasNoteDBValue = [record valueForKey:@"hasNote"];
            NSString *hasNote =[hasNoteDBValue stringValue];
            NSString *moidStr = [[[record objectID] URIRepresentation] absoluteString];
            NSString *jsEval = [NSString stringWithFormat:@"addHightlight('%@','%@','%@','%@')",moidStr,sWID,eWID,[hasNote isEqualToString:@"1"]?@"true":@"false"];
            [self stringByEvaluatingJavaScriptFromString:jsEval];
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


- (void) noWordFoundToHighlightOnLongPress
{
    
}

- (void) updateHighlightSticksPositions:(float) sID :(float) sX  :(float) sY  :(float) sW :(float) sH :(float) eID :(float)eX  :(float) eY :(float) eW :(float) eH
{
    isAddingNote = NO;
    
    
    
    sX = sX * scaleFactorPageFit;
    sY = sY * scaleFactorPageFit;
    sW = sW * scaleFactorPageFit;
    sH = sH * scaleFactorPageFit;
    eX = eX * scaleFactorPageFit;
    eY = eY * scaleFactorPageFit;
    eW = eW * scaleFactorPageFit;
    eH = eH * scaleFactorPageFit;
    
    if(!self.currHighlightVO)
    {
        self.currHighlightVO = [HighlightVO new];
    }
    
    [self.currHighlightVO setChapterPath:self.webViewDAO.chapterVO.chapterURL];
    [self.currHighlightVO setChapterIndex:[self.webViewDAO getIndexOfChapter]];
    [self.currHighlightVO setStartWordID:sID];
    [self.currHighlightVO setEndWordID:eID];
    [self.currHighlightVO setNoOfPagesInChapter:self.webViewDAO.chapterVO.pageCountInChapter];
    
    stickHeight = sH;
    
//    if(!startStick)
//    {
//        int modifiedX = sX-stickWidth - (self.frame.size.width*[self.webViewDAO getIndexOfPage]);
//        int modifiedY = sY-stickHeight/2;
//        CGRect sRect = CGRectMake(modifiedX+3, modifiedY, stickWidth, stickHeight);
//        startStick = [[StartStickView alloc] initWithFrame:sRect];
//        startStick.myWebView = self;
//        [[self superview] addSubview:startStick];
//    }
//    else
    {
        startStick.hidden = NO;
        int modifiedX = sX-stickWidth - (self.frame.size.width*[self.webViewDAO getIndexOfPage]);
        int modifiedY = sY-stickHeight/2;
        CGRect sRect = CGRectMake(modifiedX+3, modifiedY, stickWidth, stickHeight);
        startStick.frame = sRect;
    }
    stickHeight = eH;
//    if(!endStick)
//    {
//        int modifiedX = eX - (self.frame.size.width*[self.webViewDAO getIndexOfPage]);
//        int modifiedY = eY-stickHeight/2;
//        CGRect eRect = CGRectMake(modifiedX-3, modifiedY, stickWidth, stickHeight);
//        endStick = [[EndStickView alloc] initWithFrame:eRect];
//        endStick.myWebView = self;
//        [[self superview] addSubview:endStick];
//    }
//    else
    {
        endStick.hidden = NO;
        int modifiedX = eX - (self.frame.size.width*[self.webViewDAO getIndexOfPage]);
        int modifiedY = eY-stickHeight/2;
        CGRect eRect = CGRectMake(modifiedX-3, modifiedY, stickWidth, stickHeight);
        endStick.frame = eRect;
    }
}

-(void) showHighlightContextMenu:(UIView *) anchorView
{
    CGRect rect = CGRectMake(anchorView.frame.size.width/2, 0, 0, 0);
    if(!highlightPopup)
    {
        hContr = [[HighlightPopupViewController alloc ] init];
        highlightPopup= [[UIPopoverController alloc] initWithContentViewController:hContr];
        CGSize popoverContentSize = CGSizeMake(220, 60);
        highlightPopup.popoverContentSize =popoverContentSize;
    }
    [highlightPopup setDelegate:self];
    hContr.myWebView = self;
    highlightPopup.passthroughViews = [NSArray arrayWithObjects:self,startStick,endStick, nil];
    SHOULD_DISMISS = NO;
    [highlightPopup presentPopoverFromRect:rect inView:anchorView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return SHOULD_DISMISS;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if(startStick)
    {
        //[startStick removeFromSuperview];
        startStick.hidden = YES;
    }
    
    if(endStick)
    {
        //[endStick removeFromSuperview];
        endStick.hidden = YES;
    }
    SHOULD_DISMISS = NO;
    [self stringByEvaluatingJavaScriptFromString:@"setTouchedStick(false,true)"];
    
}

- (void) didTouchOnHighlightStick :(BOOL) isStartStick : (BOOL) isEndStick
{
//    if(isStartStick)
//    {
//        [self stringByEvaluatingJavaScriptFromString:@"setTouchedStick(true,false)"];
//        if(highlightPopup)
//        {
//            [highlightPopup dismissPopoverAnimated:NO];
//        }
//    }
//    else
//    {
//        [self stringByEvaluatingJavaScriptFromString:@"setTouchedStick(false,true)"];
//        if(highlightPopup)
//        {
//            [highlightPopup dismissPopoverAnimated:NO];
//        }
//    }b
    
}

- (void) addNoteAndClosePopup
{
    isAddingNote = YES;
    [self saveHighlight];
}

-(void) dealloc
{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch comes here");
}

- (void)didOpenNoteEditor
{
    [self.myDelegate didOpenNoteEditor];
   
}

- (void)didCloseNoteEditor
{
    [self.myDelegate didCloseNoteEditor];
   
}

- (void) copySelectedTextToPasteBoard:(NSString *) text
{
    
    self.currHighlightVO.selectedText = text;
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = text;
    [self closePopupAndClearHighlight];
}

- (void)didChangeBookmarkStatus:(BOOL)madeBookmark :(BOOL) byUser
{
    if(byUser)
    {
        //[self.webViewDAO setBookmarked:madeBookmark];
        if(madeBookmark)
        {
            //add bookmark vo to bookmark coll in chapter vo and save to coredata
            [self stringByEvaluatingJavaScriptFromString:@"bookmarkThisPage()"];
        }
        else
        {
            //un bookmarked this page
            //iterate all bookmarks in this chaptervo and remove those bookmarks which falls in between first word and last word id of this page
            BOOL anyRecordFailedToDelete = NO;
            if(self.webViewDAO.chapterVO.bookmarksColl)
            {
                NSMutableArray *bookmarks = self.webViewDAO.chapterVO.bookmarksColl;
                NSMutableArray *discardedItems = [NSMutableArray array];
                for(BookmarkVO *bVO in bookmarks)
                {
                    if(bVO->bookmarkedWordID >= [self.webViewDAO getFirstWordID] &&
                       bVO->bookmarkedWordID <= [self.webViewDAO getLastWordID])
                    {
                        
                        if([self deleteBookmarkFromDB:bVO])
                        {
                              [discardedItems addObject:bVO];
                        }
                        else
                        {
                            anyRecordFailedToDelete = YES;
                        }
                    }
                }
                [bookmarks removeObjectsInArray:discardedItems];
            }
            if(!anyRecordFailedToDelete)
            {
                [self.myDelegate changeBookMarkStatus:NO byUser:NO];
            }
        }
    }
}

- (BOOL) deleteBookmarkFromDB:(BookmarkVO *) vo
{
    NSManagedObjectContext *context = [self managedObjectContext];
//    NSEntityDescription *entitiyDesc = [NSEntityDescription entityForName:@"Bookmarks" inManagedObjectContext:context];
    NSURL *url = [NSURL URLWithString:[vo bookmarkID]];
    NSManagedObjectID *moID = [[context persistentStoreCoordinator] managedObjectIDForURIRepresentation:url];
    NSManagedObject *mObj = [context objectWithID:moID];
    NSError *err;
    [context deleteObject:mObj];
    [context save:&err];
    if(err)
    {
        //failed to delete record
        return NO;
    }
    return YES;
    
}
- (void) getAllBookmarksOfThisChapter
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entitiyDesc = [NSEntityDescription entityForName:@"Bookmarks" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entitiyDesc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chapter_index = %d" ,[self.webViewDAO getIndexOfChapter]];
    [request setPredicate:predicate];
    NSError *err ;
    NSArray *records = [context executeFetchRequest:request error:&err];
    
    if(!err)
    {
        self.webViewDAO.chapterVO.bookmarksColl = nil;
        self.webViewDAO.chapterVO.bookmarksColl = [[NSMutableArray alloc] init];
        for (NSManagedObject *mObj in records)
        {
            BookmarkVO *bVO = [[BookmarkVO alloc] init];
            bVO->indexOfChapter = [self.webViewDAO getIndexOfChapter];
            bVO->bookmarkedWordID = [(NSString *)[mObj valueForKey:@"word_id"] integerValue];
            [bVO setBookmarkID:[[[mObj objectID] URIRepresentation] absoluteString]];
            [bVO setBookmarkText:[mObj valueForKey:@"chapter_index"]];
            [self.webViewDAO.chapterVO.bookmarksColl addObject:bVO];
            if(bVO->bookmarkedWordID>=[self.webViewDAO getFirstWordID] &&
               bVO->bookmarkedWordID<=[self.webViewDAO getLastWordID])
            {
                [self.myDelegate changeBookMarkStatus:YES byUser:NO];
            }
        }
    }
    
}

- (void) bookmarkThisPage:(NSString *) text
{
    BookmarkVO *bVO = [[BookmarkVO alloc] init];
    bVO->indexOfChapter = [self.webViewDAO getIndexOfChapter];
    bVO->bookmarkedWordID = [self.webViewDAO getFirstWordID];
    [bVO setBookmarkText:text];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *mObj = [NSEntityDescription insertNewObjectForEntityForName:@"Bookmarks" inManagedObjectContext:context];
    [mObj setPrimitiveValue:[NSNumber numberWithInteger:bVO->indexOfChapter] forKey:@"chapter_index"];
    [mObj setPrimitiveValue:[NSNumber numberWithInteger:bVO->bookmarkedWordID] forKey:@"word_id"];
    [mObj setValue:bVO.bookmarkText forKey:@"text"];
    
    NSError *err ;
    if([context save:&err])
    {
        [bVO setBookmarkID: [[[mObj objectID] URIRepresentation] absoluteString]];
        [self.webViewDAO.chapterVO.bookmarksColl addObject:bVO];
    }
    else
    {
        //failed to bookmark this page
        [self.myDelegate changeBookMarkStatus:NO byUser:NO];
    }
}

@end
