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
    PageVO *currentPageVO;
    
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
    currentPageVO = nil;
     _myViewPager.delegate = self;
    _myViewPager.mainController = self;
    self.contentsView.mainViewController = self;
    self.contentsView.hidden = CONTENTS_VIEW_HIDDEN;
    self.helperForPageCount.frame = _myViewPager.frame;
    self.highlightBtn.hidden = YES;
    [self.pageNavSlider addTarget:self action:@selector(didSlidingFinish:) forControlEvents:UIControlEventTouchUpInside];
    [self.pageNavSlider addTarget:self action:@selector(didSlidingFinish:) forControlEvents:UIControlEventTouchCancel];
    [self.pageNavSlider addTarget:self action:@selector(didSlidingFinish:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentsView prepareTabs];
//    UIControlEventTouchUpInside *touchUpEvent = [UIControlEventTouchUpInside al];
//    self.pageNavSlider
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
    NSInteger indexOfPage = [oldPage.myWebView.pageVO getIndexOfPage];
    NSInteger indexOfChapter = [oldPage.myWebView.pageVO getIndexOfChapter];
    NSInteger pageCount = oldPage.myWebView.pageVO.chapterVO.pageCountInChapter;
    
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
            
            PageVO *pageVO = [[PageVO alloc] init];
            pageVO.chapterVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:indexOfChapter];
            [pageVO setIndexOfPage:indexOfPage];
            [pageVO setIndexOfChapter:indexOfChapter];
            
            [pageView loadViewWithData:pageVO];
            return pageView;
        }
    }
    else
    {
        //next page in same chapter
        CGRect rect = CGRectMake(0, 0, _myViewPager.frame.size.width, _myViewPager.frame.size.height);
        MyPageView *pageView = [[MyPageView alloc] initWithFrame:rect];
        
        PageVO *pageVO = [[PageVO alloc] init];
        pageVO.chapterVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:indexOfChapter];
        [pageVO setIndexOfPage:indexOfPage];
        [pageVO setIndexOfChapter:indexOfChapter];
        
        [pageView loadViewWithData:pageVO];
        return pageView;
    }
    
    return nil;
}

- (UIView *)getPreviousPage:(UIView *)oldPageView
{
    MyPageView *oldPage = (MyPageView *)oldPageView;
    NSInteger indexOfPage = [oldPage.myWebView.pageVO getIndexOfPage];
    NSInteger indexOfChapter = [oldPage.myWebView.pageVO getIndexOfChapter];
    NSInteger pageCount = oldPage.myWebView.pageVO.chapterVO.pageCountInChapter;
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
            
            PageVO *pageVO = [[PageVO alloc] init];
            pageVO.chapterVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:indexOfChapter];
            [pageVO setIndexOfPage:PAGE_INDEX_GREATER_THAN_PAGE_COUNT];
            [pageVO setIndexOfChapter:indexOfChapter];
            
            [pageView loadViewWithData:pageVO];
            return pageView;
        }
    }
    else if(indexOfPage <= pageCount-1)
    {
        //same chapter previous page
        CGRect rect = CGRectMake(0, 0, _myViewPager.frame.size.width, _myViewPager.frame.size.height);
        MyPageView *pageView = [[MyPageView alloc] initWithFrame:rect];
        
        PageVO *pageVO = [[PageVO alloc] init];
        pageVO.chapterVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:indexOfChapter];
        [pageVO setIndexOfPage:indexOfPage];
        [pageVO setIndexOfChapter:indexOfChapter];
        
        [pageView loadViewWithData:pageVO];
        return pageView;
    }
    return oldPageView;
}



- (void)openBook
{
    currentPageVO = nil;
    [self.bookLoadingIndicatorView setHidden:NO];
    [self.bookLoadActInd startAnimating];
    currentPageNo = 1;
    [self restorePlayerToLastSavedState];
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
    MyPageView *myPageView = (MyPageView *)[_myViewPager getCurrentPageView];
    [myPageView.myWebView didHighlightButtonTap];
    
    myPageView.touchHelperView.userInteractionEnabled = !HIGHLIGHT_TOOL_SWITCH;
    self.btnFontDecrease.userInteractionEnabled = !HIGHLIGHT_TOOL_SWITCH;
    self.btnFontIncrease.userInteractionEnabled = !HIGHLIGHT_TOOL_SWITCH;
}

- (IBAction)toggleDataBankLayout:(id)sender
{
    CONTENTS_VIEW_HIDDEN = !CONTENTS_VIEW_HIDDEN;
    
    [self switchContentsLayout:CONTENTS_VIEW_HIDDEN];
    
}

- (void) switchContentsLayout:(BOOL) hide
{
    CGRect basketTopFrame = self.contentsView.frame;
    UIViewAnimationOptions option ;
    if(hide)
    {
        basketTopFrame.origin.x = -self.contentsView.frame.size.width;
        option = UIViewAnimationOptionCurveEaseOut;
        self.contentsView.frame = CGRectMake(0, self.contentsView.frame.origin.y, self.contentsView.frame.size.width, self.contentsView.frame.size.height);
    }
    else
    {
        [self.contentsView refresh];
        self.contentsView.hidden = hide;
        basketTopFrame.origin.x = 0;
        option = UIViewAnimationOptionCurveEaseIn;
        self.contentsView.frame = CGRectMake(-self.contentsView.frame.size.width, self.contentsView.frame.origin.y, self.contentsView.frame.size.width, self.contentsView.frame.size.height);
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:option
                     animations:^{
                         self.contentsView.frame = basketTopFrame;
                     }
                     completion:^(BOOL finished)
     {
         self.contentsView.hidden = hide;
         CONTENTS_VIEW_HIDDEN = hide;
     }];
}

- (void) didOpenNoteEditor
{
    MyPageView *myPageView = (MyPageView *)[_myViewPager getCurrentPageView];
    myPageView.touchHelperView.userInteractionEnabled = NO;
    self.btnFontDecrease.userInteractionEnabled = NO;
    self.btnFontIncrease.userInteractionEnabled = NO;
}

- (void) didCloseNoteEditor
{
    MyPageView *myPageView = (MyPageView *)[_myViewPager getCurrentPageView];
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
        self.pageNavSlider.value = pageNo;
    }
    [self.pageNoLable setText:[NSString stringWithFormat:@"%d / %d",pageNo, [BookModelFactory sharedInstance].pageCountInBook]];
}

-(void) didSlidingFinish:(UIControlEvents *) events
{
    int pageNo = [NSNumber numberWithFloat:roundf(self.pageNavSlider.value)].intValue;
    if(pageNo<1)
    {
        pageNo = 1;
        self.pageNavSlider.value = pageNo;
    }
    if(pageNo != currentPageNo)
    {
        currentPageNo = pageNo;
        
        [self.pageNoLable setText:[NSString stringWithFormat:@"%d / %d",pageNo, [BookModelFactory sharedInstance].pageCountInBook]];
        PageVO *dao = [Utils getPageVO:pageNo];
        if(dao)
        {
            CGRect rect = CGRectMake(0, 0, _myViewPager.frame.size.width, _myViewPager.frame.size.height);
            MyPageView *pageView = [[MyPageView alloc] initWithFrame:rect];
            
            PageVO *pageVO = [[PageVO alloc] init];
            pageVO.chapterVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:[dao getIndexOfChapter]];
            [pageVO setIndexOfPage:[dao getIndexOfPage]];
            [pageVO setIndexOfChapter:[dao getIndexOfChapter]];
            [pageView loadViewWithData:pageVO];
            
            [_myViewPager initWithPageView:pageView];
        }
    }
}
- (void) didCompletePageCounting:(int) count
{
    [self.pageNoLable setText:[NSString stringWithFormat:@"%d / %d",1, [BookModelFactory sharedInstance].pageCountInBook]];
    CGRect rect = CGRectMake(0, 0, _myViewPager.frame.size.width, _myViewPager.frame.size.height);
    MyPageView *pageView = [[MyPageView alloc] initWithFrame:rect];
    
    
    if(currentPageVO)
    {
        ChapterVO *vo = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:[currentPageVO getIndexOfChapter]];
        currentPageVO.chapterVO = vo;
        if([currentPageVO getIndexOfPage]>=[vo pageCountInChapter])
        {
            [currentPageVO setIndexOfPage:vo.pageCountInChapter-1];
        }
    }
    else
    {
        currentPageVO = [[PageVO alloc] init];
        //NSArray *arr = [[BookModelFactory sharedInstance] chaptersColl];
        currentPageVO.chapterVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:0];
        [currentPageVO setIndexOfPage:0];
        [currentPageVO setIndexOfChapter:0];
    }
    [pageView loadViewWithData:currentPageVO];
    [_myViewPager initWithPageView:pageView];
    [self.bookLoadActInd stopAnimating];
//    [self.bookLoadingIndicatorView setHidden:YES];
    [self.bookLoadingIndicatorView removeFromSuperview];
    [self.pageNavSlider setMaximumValue:count];
    int pageNo =[Utils getPageNoFromPageVO: currentPageVO];
    if(pageNo != -1)
    {
        [self updatePageNavSliderValue:pageNo];
    }
}

- (void) updatePageNavSliderValue:(int)value
{
    self.pageNavSlider.value = value;
    currentPageNo = value;
    [self.pageNoLable setText:[NSString stringWithFormat:@"%d / %d",value, [BookModelFactory sharedInstance].pageCountInBook]];
}

- (void) didPageChange:(MyPageView *) currentPageView
{
    currentPageVO = nil;
    currentPageVO =currentPageView.myWebView.pageVO;
    
    int pageNo =[Utils getPageNoFromPageVO: currentPageVO];
    if(pageNo != -1)
    {
        [self updatePageNavSliderValue:pageNo];
        [self savePlayerStatus];
    }
}



- (void) savePlayerStatus
{
    if(currentPageVO)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        // NSMutableDictionary *lastVisitedPage = [[NSMutableDictionary alloc] init];
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:currentPageVO];
        [userDefaults setObject:encodedObject forKey:@"LastVisitedPageInfo"];
        [userDefaults setValue:[NSNumber numberWithInteger:CURRENT_FONT_SIZE] forKey:@"FontSize"];
        
        [userDefaults synchronize];

    }
}

- (void) restorePlayerToLastSavedState
{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int fontsize = ((NSNumber *)[userDefaults valueForKey:@"FontSize"]).integerValue;
    if(fontsize !=0)
    {
        CURRENT_FONT_SIZE = fontsize;
    }
    currentPageVO = [self getLastVisitedPageInfo];
    
}

- (PageVO *) getLastVisitedPageInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    PageVO *decodedObject = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"LastVisitedPageInfo"]];
    return decodedObject;
}

- (void) navigateToPage:(PageVO *) pageVO
{
    CGRect rect = CGRectMake(0, 0, _myViewPager.frame.size.width, _myViewPager.frame.size.height);
    MyPageView *pageView = [[MyPageView alloc] initWithFrame:rect];
    [pageView loadViewWithData:pageVO];
    [_myViewPager initWithPageView:pageView];
    [self switchContentsLayout:YES];
}

@end
