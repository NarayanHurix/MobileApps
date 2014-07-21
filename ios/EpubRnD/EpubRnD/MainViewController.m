//
//  MainViewController.m
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "MainViewController.h"
#import "MyPageView.h"
#include "GlobalSettings.h"

@interface MainViewController ()
{
    int currentPageNo;
    WebViewDAO *currentPageWebViewDAO;
    
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _myViewPager.delegate = self;
    _myViewPager.mainController = self;
    self.helperForPageCount.frame = _myViewPager.frame;
    self.highlightBtn.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIView *)getFirstPage
//{
//    CGRect parentFrame = [self.view frame];
//    MyPageView *pageView = [[MyPageView alloc] initWithFrame:parentFrame];
//    
//    WebViewDAO *webDAO = [WebViewDAO new];
//    webDAO.chapterVO = [self.data objectAtIndex:0];
//    [webDAO setIndexOfPage:0];
//    [webDAO setIndexOfChapter:0];
//    
//    [pageView loadViewWithData:webDAO];
//    return  pageView;
//}

- (UIView *)getNextPage:(UIView *)oldPageView
{
    MyPageView *oldPage = (MyPageView *)oldPageView;
    NSInteger indexOfPage = [oldPage.myWebView.webViewDAO getIndexOfPage];
    NSInteger indexOfChapter = [oldPage.myWebView.webViewDAO getIndexOfChapter];
    NSInteger pageCount = [oldPage.myWebView.webViewDAO getPageCount];
    
    indexOfPage++;
    if(indexOfPage>=pageCount)
    {
        indexOfPage = 0;
        indexOfChapter++;
        if(indexOfChapter >= [[BookModelFactory sharedInstance] chaptersColl].count)
        {
            //end of the chapters and pages so return the same page
            indexOfChapter--;
            return nil;
        }
        else
        {
            //next chapter first page
            CGRect rect = CGRectMake(0, 0, _myViewPager.frame.size.width, _myViewPager.frame.size.height);
            MyPageView *pageView = [[MyPageView alloc] initWithFrame:rect];
            
            WebViewDAO *webDAO = [WebViewDAO new];
            webDAO.chapterVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:indexOfChapter];
            [webDAO setIndexOfPage:indexOfPage];
            [webDAO setIndexOfChapter:indexOfChapter];
            
            [pageView loadViewWithData:webDAO];
            return pageView;
        }
    }
    else
    {
        //next page in same chapter
        CGRect rect = CGRectMake(0, 0, _myViewPager.frame.size.width, _myViewPager.frame.size.height);
        MyPageView *pageView = [[MyPageView alloc] initWithFrame:rect];
        
        WebViewDAO *webDAO = [WebViewDAO new];
        webDAO.chapterVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:indexOfChapter];
        [webDAO setIndexOfPage:indexOfPage];
        [webDAO setIndexOfChapter:indexOfChapter];
        
        [pageView loadViewWithData:webDAO];
        return pageView;
    }
    
    return nil;
}

- (UIView *)getPreviousPage:(UIView *)oldPageView
{
    MyPageView *oldPage = (MyPageView *)oldPageView;
    NSInteger indexOfPage = [oldPage.myWebView.webViewDAO getIndexOfPage];
    NSInteger indexOfChapter = [oldPage.myWebView.webViewDAO getIndexOfChapter];
    NSInteger pageCount = [oldPage.myWebView.webViewDAO getPageCount];
    indexOfPage--;
    if(indexOfPage<0)
    {
        indexOfPage = 0;
        indexOfChapter--;
        if(indexOfChapter<0)
        {
            //return the same page
            return nil;
        }
        else
        {
            //previous chapter last page
            CGRect rect = CGRectMake(0, 0, _myViewPager.frame.size.width, _myViewPager.frame.size.height);
            MyPageView *pageView = [[MyPageView alloc] initWithFrame:rect];
            
            WebViewDAO *webDAO = [WebViewDAO new];
            webDAO.chapterVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:indexOfChapter];
            [webDAO setIndexOfPage:-2];
            [webDAO setIndexOfChapter:indexOfChapter];
            
            [pageView loadViewWithData:webDAO];
            
            return pageView;
        }
    }
    else if(indexOfPage <= pageCount-1)
    {
        //same chapter previous page
        CGRect rect = CGRectMake(0, 0, _myViewPager.frame.size.width, _myViewPager.frame.size.height);
        MyPageView *pageView = [[MyPageView alloc] initWithFrame:rect];
        
        WebViewDAO *webDAO = [WebViewDAO new];
        webDAO.chapterVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:indexOfChapter];
        [webDAO setIndexOfPage:indexOfPage];
        [webDAO setIndexOfChapter:indexOfChapter];
        
        [pageView loadViewWithData:webDAO];
        return pageView;
    }
    return oldPageView;
}



- (void)openBook
{
    currentPageWebViewDAO = nil;
    [self.bookLoadingIndicatorView setHidden:NO];
    [self.bookLoadActInd startAnimating];
    currentPageNo = 1;
    [self.helperForPageCount startPageCounting:self];
    
}


- (IBAction)closeBook:(UIButton *)sender
{
    HIGHLIGHT_TOOL_SWITCH = NO;
    [self.view removeFromSuperview];
}



//- (void)onPageOutOfRange
//{
//    [self getPreiousPage:_myViewPager.currenPageView];
//}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
//    CGRect parentFrame = [self.view frame];
//    [_myViewPager.currenPageView setFrame:parentFrame];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    CGRect parentFrame = [self.view frame];
//    [_myViewPager.currenPageView setFrame:parentFrame];
}

- (BOOL)shouldAutorotate
{
//    CGRect parentFrame = [self.view frame];
//    [_myViewPager.currenPageView setFrame:parentFrame];
    return YES;
}

- (void)viewDidLayoutSubviews
{
//    CGRect parentFrame = [self.view frame];
//    [_myViewPager.currenPageView setFrame:parentFrame];
//    [((MyWebView *)_myViewPager.currenPageView)  setFrame:parentFrame];
}

- (IBAction)penToolEnable:(UIButton *)sender
{
    
    PEN_TOOL_SWITCH = PEN_TOOL_SWITCH?NO:YES;
    
    [self performSelector:@selector(count) withObject:nil afterDelay:0];
}

- (IBAction)onTapHighlightBtn:(UIButton *)sender
{
    [self toggleHighlightSwitch];
}

- (void) toggleHighlightSwitch
{
    HIGHLIGHT_TOOL_SWITCH = HIGHLIGHT_TOOL_SWITCH?NO:YES;
    [self.highlightBtn setSelected:HIGHLIGHT_TOOL_SWITCH];
    MyPageView *myPageView = (MyPageView *)_myViewPager.currenPageView;
    [myPageView.myWebView didHighlightButtonTap];
    
    myPageView.touchHelperView.userInteractionEnabled = !HIGHLIGHT_TOOL_SWITCH;
    self.btnFontDecrease.userInteractionEnabled = !HIGHLIGHT_TOOL_SWITCH;
    self.btnFontIncrease.userInteractionEnabled = !HIGHLIGHT_TOOL_SWITCH;
}

- (void) didOpenNoteEditor
{
    MyPageView *myPageView = (MyPageView *)_myViewPager.currenPageView;
    myPageView.touchHelperView.userInteractionEnabled = NO;
    self.btnFontDecrease.userInteractionEnabled = NO;
    self.btnFontIncrease.userInteractionEnabled = NO;
}

- (void) didCloseNoteEditor
{
    MyPageView *myPageView = (MyPageView *)_myViewPager.currenPageView;
    myPageView.touchHelperView.userInteractionEnabled = YES;
    self.btnFontDecrease.userInteractionEnabled = YES;
    self.btnFontIncrease.userInteractionEnabled = YES;
}

- (IBAction)decreaseFontSize:(UIButton *)sender
{
    if(EPUB_LAYOUT_TYPE == REFLOWABLE)
    {
        CURRENT_FONT_SIZE-=FONT_SIZE_STEP_SIZE;
        if(CURRENT_FONT_SIZE<MIN_FONT_SIZE)
        {
            CURRENT_FONT_SIZE+=FONT_SIZE_STEP_SIZE;
        }
        else
        {
            [self.helperForPageCount startPageCounting:self];
            
    //        MyPageView *myPageView = (MyPageView *)_myViewPager.currenPageView;
    //        [myPageView.myWebView updateFontSize];
    //        [_myViewPager refreshAdjacentPages];
        }
    }
    else
    {
        
    }
}

- (IBAction)increaseFontSize:(UIButton *)sender
{
    if(EPUB_LAYOUT_TYPE == REFLOWABLE)
    {
        CURRENT_FONT_SIZE+=FONT_SIZE_STEP_SIZE;
        if(CURRENT_FONT_SIZE>MAX_FONT_SIZE)
        {
            CURRENT_FONT_SIZE-=FONT_SIZE_STEP_SIZE;
        }
        else
        {
            [self.helperForPageCount startPageCounting:self];
    //        MyPageView *myPageView = (MyPageView *)_myViewPager.currenPageView;
    //        [myPageView.myWebView updateFontSize];
    //        [_myViewPager refreshAdjacentPages];
        }
    }
    else
    {
        
    }
}

- (void)didSliderValueChange:(UISlider *)sender
{
    int pageNo = [NSNumber numberWithFloat:roundf(sender.value)].intValue;
    if(pageNo<1)
    {
        pageNo = 1;
    }
    if(pageNo != currentPageNo)
    {
        currentPageNo = pageNo;
        
        [self.pageNoLable setText:[NSString stringWithFormat:@"%d / %d",pageNo, [BookModelFactory sharedInstance].pageCountInBook]];
        WebViewDAO *dao = [self getPageWebViewDAO:pageNo];
        if(dao)
        {
            CGRect rect = CGRectMake(0, 0, _myViewPager.frame.size.width, _myViewPager.frame.size.height);
            MyPageView *pageView = [[MyPageView alloc] initWithFrame:rect];

            WebViewDAO *webDAO = [WebViewDAO new];
            webDAO.chapterVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:[dao getIndexOfChapter]];
            [webDAO setIndexOfPage:[dao getIndexOfPage]];
            [webDAO setIndexOfChapter:[dao getIndexOfChapter]];
            [webDAO setPageCount:webDAO.chapterVO.pageCountInChapter];
            [pageView loadViewWithData:webDAO];

            [_myViewPager initWithPageView:pageView];
        }
    }
}

- (void) didCompletePageCounting:(int) count
{
    [self.pageNoLable setText:[NSString stringWithFormat:@"%d / %d",1, [BookModelFactory sharedInstance].pageCountInBook]];
    CGRect rect = CGRectMake(0, 0, _myViewPager.frame.size.width, _myViewPager.frame.size.height);
    MyPageView *pageView = [[MyPageView alloc] initWithFrame:rect];
    
    
    if(currentPageWebViewDAO)
    {
        ChapterVO *vo = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:[currentPageWebViewDAO getIndexOfChapter]];
        if([currentPageWebViewDAO getIndexOfPage]>=[vo pageCountInChapter])
        {
            [currentPageWebViewDAO setIndexOfPage:vo.pageCountInChapter-1];
        }
        
        [pageView loadViewWithData:currentPageWebViewDAO];
    }
    else
    {
        currentPageWebViewDAO = [WebViewDAO new];
        NSArray *arr = [[BookModelFactory sharedInstance] chaptersColl];
        currentPageWebViewDAO.chapterVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:0];
        [currentPageWebViewDAO setIndexOfPage:0];
        [currentPageWebViewDAO setIndexOfChapter:0];
        [currentPageWebViewDAO setPageCount:currentPageWebViewDAO.chapterVO.pageCountInChapter];
        [pageView loadViewWithData:currentPageWebViewDAO];
    }
    
    [_myViewPager initWithPageView:pageView];
    [self.bookLoadActInd stopAnimating];
//    [self.bookLoadingIndicatorView setHidden:YES];
    [self.bookLoadingIndicatorView removeFromSuperview];
    [self.pageNavSlider setMaximumValue:count];
}

- (void) updatePageNavSliderValue:(int)value
{
    self.pageNavSlider.value = value;
    currentPageNo = value;
    [self.pageNoLable setText:[NSString stringWithFormat:@"%d / %d",value, [BookModelFactory sharedInstance].pageCountInBook]];
}

- (void) didPageChange:(MyPageView *) currentPageView
{
    currentPageWebViewDAO =currentPageView.myWebView.webViewDAO;
    int pageNo =[self getPageNoFromPageWebViewDAO: currentPageWebViewDAO];
    if(pageNo != -1)
    {
        [self updatePageNavSliderValue:pageNo];
    }
}

- (WebViewDAO *) getPageWebViewDAO:(int) pageNo
{
    int arrLength = [[BookModelFactory sharedInstance] chaptersColl].count;
    int tempPageCount = 0;
    for (int i=0; i<arrLength; i++)
    {
        ChapterVO *tempCVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:i];
        tempPageCount+= tempCVO.pageCountInChapter;
        if(pageNo<=tempPageCount)
        {
            WebViewDAO *dao = [WebViewDAO new];
            [dao setIndexOfChapter:i];
            [dao setIndexOfPage:(pageNo - (tempPageCount-tempCVO.pageCountInChapter))-1];
            return dao;
        }
    }
    
    return Nil;
}

- (int) getPageNoFromPageWebViewDAO:(WebViewDAO *) dao
{
    int arrLength = [[BookModelFactory sharedInstance] chaptersColl].count;
    int tempPageCount = 0;
    for (int i=0; i<arrLength; i++)
    {
        ChapterVO *tempCVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:i];
        tempPageCount+= tempCVO.pageCountInChapter;
        if(i == [dao getIndexOfChapter])
        {
            return tempPageCount-tempCVO.pageCountInChapter+([dao getIndexOfPage]+1);
        }
    }
    return -1;
}

@end
