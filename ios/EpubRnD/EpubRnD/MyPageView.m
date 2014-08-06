//
//  MyPageView.m
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "MyPageView.h"
#import "MyViewPager.h"
#import "MainViewController.h"

@class StickyNoteView;

@implementation MyPageView
{
    UIBezierPath *path;
}

@synthesize myWebView,activityIndicator,touchHelperView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        path = [UIBezierPath bezierPath];
//        [path setLineWidth:2.0];
        NSLog(@"my page view created");
        
    }
    return self;
}

- (void) loadViewWithData:(PageVO *) data
{
    CGRect parentFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    myWebView = [[MyWebView alloc] initWithFrame:parentFrame];
    [myWebView loadViewWithData:data];
    myWebView.myDelegate = self;
    
    touchHelperView = [[UIView alloc] initWithFrame:parentFrame];
    [self addSubview:myWebView];
    [self addSubview:touchHelperView];
    [self bringSubviewToFront:touchHelperView];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator hidesWhenStopped];
    activityIndicator.frame = CGRectMake(0, 0, 100, 100);
    [self addSubview:activityIndicator];
    activityIndicator.center = self.center;
    [activityIndicator startAnimating];
    
    CGRect bookmarkFrame = CGRectMake(self.frame.size.width-DEFAULT_BOOKMARK_WIDTH-20, 5, DEFAULT_BOOKMARK_WIDTH, DEFAULT_BOOKMARK_HEIGHT);
    self.bookmarkView = [[BookmarkView alloc] initWithFrame: bookmarkFrame ];
    self.bookmarkView.myDelegate = myWebView;
    [self addSubview:self.bookmarkView];
    self.bookmarkView.hidden = YES;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)myWebViewBeganLoading
{
    myWebView.hidden = YES;
    [self cleanPageMarkups];
    [activityIndicator startAnimating];
}

- (void)myWebViewDidLoadFinish
{
    [activityIndicator stopAnimating];
    myWebView.hidden = NO;
    self.bookmarkView.hidden = NO;
    [self bringSubviewToFront:self.bookmarkView];
}

- (void)myWebViewOnPageOutOfRange
{
    MyViewPager *viewPager = (MyViewPager *)[self superview];
    //MainViewController *controller = (MainViewController *)viewPager.mainController;
    [viewPager onPageOutOfRange];
}

- (void) toggleHighlightSwitch
{
    MyViewPager *viewPager = (MyViewPager *)[self superview];
    [viewPager.delegate toggleHighlightSwitch];
}

//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    [[UIColor whiteColor] setStroke];
//    [path stroke];
//}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
//    
////    [path moveToPoint:p];
//    UIView *view = [self hitTest:p withEvent:event];
//    
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
////    [path addLineToPoint:p]; // (4)
////    [self setNeedsDisplay];
//    [self hitTest:p withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
////    [self touchesMoved:touches withEvent:event];
//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
//    
//    [self hitTest:p withEvent:event];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
////    [self touchesEnded:touches withEvent:event];
//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
//    
//    [self hitTest:p withEvent:event];
//}

- (void)didOpenNoteEditor
{
    MyViewPager *viewPager = (MyViewPager *)[self superview];
    MainViewController *controller = (MainViewController *)viewPager.mainController;
    [controller didOpenNoteEditor];
}

- (void)didCloseNoteEditor
{
    MyViewPager *viewPager = (MyViewPager *)[self superview];
    MainViewController *controller = (MainViewController *)viewPager.mainController;
    [controller didCloseNoteEditor];
}

- (void) changeBookMarkStatus:(BOOL) isBookmarked byUser:(BOOL) byUser
{
    [self.bookmarkView changeBookMarkStatus:isBookmarked byUser:byUser];
}

- (void) disableBookmark:(BOOL) disable
{
    [self.bookmarkView setHidden:disable];
}

- (void)dealloc
{
    NSLog(@"my page view released");
}

- (void) cleanPageMarkups
{
    for (UIView *view in self.subviews)
    {
        if(view.class == StickyNoteView.class)
        {
            [view removeFromSuperview];
        }
    }
}


@end
