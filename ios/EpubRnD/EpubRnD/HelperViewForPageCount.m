//
//  HelperViewForPageCount.m
//  EpubRnD
//
//  Created by UdaySravan K on 09/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "HelperViewForPageCount.h"
#import "ChapterVO.h"

@implementation HelperViewForPageCount
{
    id<ComputePageCountInBookDelgate> pageCountDelegate;
    int pageCount;
    int indexOfCurrentCumputingChapterVO;
    ChapterVO *currentComputingChapter;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
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

- (void) startPageCounting:(id<ComputePageCountInBookDelgate>) delegate
{
    pageCount = 0;
    indexOfCurrentCumputingChapterVO = 0;
    pageCountDelegate = delegate;
    self.delegate = self;
    if([BookModelFactory sharedInstance].chaptersColl.count>0)
    {
        currentComputingChapter = [[BookModelFactory sharedInstance].chaptersColl objectAtIndex:indexOfCurrentCumputingChapterVO];
        [self computePagesInChapter];
    }
}
- (void) computePagesInChapter
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:currentComputingChapter.chapterURL  ofType:@"xhtml" inDirectory:@"assets/cole-voyage-of-life-20120320/EPUB/xhtml"];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *urlRqst = [NSURLRequest requestWithURL:url];
    [self loadRequest:urlRqst];
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
    float actualValue = (float)contentSize.width/(float)webView.frame.size.width;
    int roundedValue =actualValue;
    currentComputingChapter.pageCountInChapter = contentSize.width/webView.frame.size.width;
    if((actualValue-roundedValue)>0)
    {
        currentComputingChapter.pageCountInChapter = currentComputingChapter.pageCountInChapter +1;
    }
    
    pageCount += currentComputingChapter.pageCountInChapter;
    NSLog(@"content width : %f ,frame width : %f ,my page count : %f",contentSize.width,webView.frame.size.width,contentSize.width/webView.frame.size.width);
    NSLog(@"Page Count updated : %d",pageCount);
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self setPagination:webView];
    indexOfCurrentCumputingChapterVO++;
    if(indexOfCurrentCumputingChapterVO <[BookModelFactory sharedInstance].chaptersColl.count)
    {
        currentComputingChapter = [[BookModelFactory sharedInstance].chaptersColl objectAtIndex:indexOfCurrentCumputingChapterVO];
        [self computePagesInChapter];
    }
    else
    {
        indexOfCurrentCumputingChapterVO = 0;
        [BookModelFactory sharedInstance].pageCountInBook = pageCount;
        [pageCountDelegate didCompletePageCounting:pageCount];
    }
}
@end
