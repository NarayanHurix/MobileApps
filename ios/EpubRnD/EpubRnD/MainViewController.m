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
        if(indexOfChapter >= self.data.count)
        {
            //end of the chapters and pages so return the same page
            indexOfChapter--;
            return nil;
        }
        else
        {
            //next chapter first page
            CGRect parentFrame = [self.view frame];
            MyPageView *pageView = [[MyPageView alloc] initWithFrame:parentFrame];
            
            WebViewDAO *webDAO = [WebViewDAO new];
            webDAO.chapterVO = [self.data objectAtIndex:indexOfChapter];
            [webDAO setIndexOfPage:indexOfPage];
            [webDAO setIndexOfChapter:indexOfChapter];
            
            [pageView loadViewWithData:webDAO];
            return pageView;
        }
    }
    else
    {
        //next page in same chapter
        CGRect parentFrame = [self.view frame];
        MyPageView *pageView = [[MyPageView alloc] initWithFrame:parentFrame];
        
        WebViewDAO *webDAO = [WebViewDAO new];
        webDAO.chapterVO = [self.data objectAtIndex:indexOfChapter];
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
            CGRect parentFrame = [self.view frame];
            MyPageView *pageView = [[MyPageView alloc] initWithFrame:parentFrame];
            
            WebViewDAO *webDAO = [WebViewDAO new];
            webDAO.chapterVO = [self.data objectAtIndex:indexOfChapter];
            [webDAO setIndexOfPage:-2];
            [webDAO setIndexOfChapter:indexOfChapter];
            
            [pageView loadViewWithData:webDAO];
            
            return pageView;
        }
    }
    else if(indexOfPage <= pageCount-1)
    {
        //same chapter previous page
        CGRect parentFrame = [self.view frame];
        MyPageView *pageView = [[MyPageView alloc] initWithFrame:parentFrame];
        
        WebViewDAO *webDAO = [WebViewDAO new];
        webDAO.chapterVO = [self.data objectAtIndex:indexOfChapter];
        [webDAO setIndexOfPage:indexOfPage];
        [webDAO setIndexOfChapter:indexOfChapter];
        
        [pageView loadViewWithData:webDAO];
        return pageView;
    }
    return oldPageView;
}
 
- (void)setBookData:(NSArray *)data
{
    self.data = data;
    CGRect parentFrame = [self.view frame];
    MyPageView *pageView = [[MyPageView alloc] initWithFrame:parentFrame];
    
    WebViewDAO *webDAO = [WebViewDAO new];
    webDAO.chapterVO = [data objectAtIndex:0];
    [webDAO setIndexOfPage:0];
    [webDAO setIndexOfChapter:0];
    
    [pageView loadViewWithData:webDAO];
    
    [_myViewPager initWithPageView:pageView];
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
    HIGHLIGHT_TOOL_SWITCH = HIGHLIGHT_TOOL_SWITCH?NO:YES;
    [sender setSelected:HIGHLIGHT_TOOL_SWITCH];
    MyPageView *myPageView = (MyPageView *)_myViewPager.currenPageView;
    [myPageView.myWebView didHighlightButtonTap];
    
    myPageView.touchHelperView.userInteractionEnabled = !HIGHLIGHT_TOOL_SWITCH;
    self.btnFontDecrease.userInteractionEnabled = !HIGHLIGHT_TOOL_SWITCH;
    self.btnFontIncrease.userInteractionEnabled = !HIGHLIGHT_TOOL_SWITCH;
}

- (IBAction)decreaseFontSize:(UIButton *)sender
{
    CURRENT_FONT_SIZE-=FONT_SIZE_STEP_SIZE;
    if(CURRENT_FONT_SIZE<MIN_FONT_SIZE)
    {
        CURRENT_FONT_SIZE+=FONT_SIZE_STEP_SIZE;
    }
    else
    {
        MyPageView *myPageView = (MyPageView *)_myViewPager.currenPageView;
        [myPageView.myWebView updateFontSize];
        [_myViewPager refreshAdjacentPages];
    }
}

- (IBAction)increaseFontSize:(UIButton *)sender
{
    CURRENT_FONT_SIZE+=FONT_SIZE_STEP_SIZE;
    if(CURRENT_FONT_SIZE>MAX_FONT_SIZE)
    {
        CURRENT_FONT_SIZE-=FONT_SIZE_STEP_SIZE;
    }
    else
    {
        MyPageView *myPageView = (MyPageView *)_myViewPager.currenPageView;
        [myPageView.myWebView updateFontSize];
        [_myViewPager refreshAdjacentPages];
    }
}

@end
