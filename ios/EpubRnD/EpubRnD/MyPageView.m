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
        
    }
    return self;
}

- (void) loadViewWithData:(WebViewDAO *) data
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
    [activityIndicator startAnimating];
}

- (void)myWebViewDidLoadFinish
{
    [activityIndicator stopAnimating];
    myWebView.hidden = NO;
}

- (void)myWebViewOnPageOutOfRange
{
    MyViewPager *viewPager = (MyViewPager *)[self superview];
    //MainViewController *controller = (MainViewController *)viewPager.mainController;
    [viewPager onPageOutOfRange];
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
//    [path moveToPoint:p];
//    
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
//    [path addLineToPoint:p]; // (4)
//    [self setNeedsDisplay];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self touchesEnded:touches withEvent:event];
//}

@end
