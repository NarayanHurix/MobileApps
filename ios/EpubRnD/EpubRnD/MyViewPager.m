//
//  MyViewPager.m
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "MyViewPager.h"
#import "GlobalConstants.h"
#import "GlobalSettings.h"

@implementation MyViewPager

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeLeft:)];
        [swipeLeft setDirection: UISwipeGestureRecognizerDirectionLeft ];
        [self addGestureRecognizer:swipeLeft];
    
    
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeRight:)];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:swipeRight];
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

- (void) initWithPageView:(UIView *) view
{
    self.currenPageView = view;
    [self removeAllSubViews:self];
    [self addSubview:view];
}


- (void) onSwipeLeft:(UISwipeGestureRecognizer *)gesture
{
    if(!HIGHLIGHT_TOOL_SWITCH)
    {
        UIView *oldPage = self.currenPageView;
        UIView *nextPage =  [_delegate getNextPage:oldPage];
        self.currenPageView = nextPage;
    
        if(oldPage != self.currenPageView)
        {
            [self removeAllSubViews:self];
            [self addSubview:nextPage];
        }
    }
}

- (void) onSwipeRight:(UISwipeGestureRecognizer *)gesture
{
    if(!HIGHLIGHT_TOOL_SWITCH)
    {
        //previous PageView
        UIView *oldPage = self.currenPageView;
        UIView *previousPage = [_delegate getPreiousPage:oldPage];
        self.currenPageView = previousPage;
    
        if(oldPage != self.currenPageView)
        {
            [self removeAllSubViews:self];
            [self addSubview:previousPage];
        }
    }
}


- (void) removeAllSubViews:(UIView *) parentView
{
    
    NSArray *viewsToRemove = [parentView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

- (void)onPageOutOfRange
{
    [self onSwipeRight:nil];
}


@end
