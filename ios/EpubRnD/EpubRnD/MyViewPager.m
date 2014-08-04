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

const int MIN_MOVE_TO_CHANGE_PAGE = 120;

@implementation MyViewPager
{
    CGPoint startTouchPoint ,endTouchPoint;
    MyPageView *adjacentNext,*adjacentPrev;
    int offsetX,offsetY;
    BOOL adjucentPagesLoaded;
    BOOL pendingPageAnimCompleted;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        
//        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeLeft:)];
//        [swipeLeft setDirection: UISwipeGestureRecognizerDirectionLeft ];
//        [self addGestureRecognizer:swipeLeft];
//    
//    
//        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeRight:)];
//        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
//        [self addGestureRecognizer:swipeRight];
//        self.userInteractionEnabled = YES;

        UILongPressGestureRecognizer *longPressGest= [[UILongPressGestureRecognizer alloc ] initWithTarget:self action:@selector(onLongPress:)];
        [self addGestureRecognizer:longPressGest];
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

- (void) initWithPageView:(MyPageView *) view
{
    adjucentPagesLoaded = NO;
    adjacentNext = Nil;
    adjacentPrev = Nil;
    self.currenPageView = Nil;
    
    self.currenPageView = view;
    [self removeAllSubViews:self];
    [self addSubview:self.currenPageView];
    pendingPageAnimCompleted = YES;
    
    [self checkAdjacentPagesLoaded];
}


- (void) onSwipeLeft:(UISwipeGestureRecognizer *)gesture
{
    if(!HIGHLIGHT_TOOL_SWITCH)
    {
        MyPageView *oldPage = self.currenPageView;
        MyPageView *nextPage =  [_delegate getNextPage:oldPage];
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
        MyPageView *oldPage = self.currenPageView;
        MyPageView *previousPage = [_delegate getPreviousPage:oldPage];
        self.currenPageView = previousPage;
    
        if(oldPage != self.currenPageView)
        {
            [self removeAllSubViews:self];
            [self addSubview:previousPage];
        }
    }
}

- (void) onLongPress:(UILongPressGestureRecognizer *) gesture
{
    if(!HIGHLIGHT_TOOL_SWITCH)
    {
        CGPoint touchLocation = [gesture locationInView:self];
        [_delegate toggleHighlightSwitch];
        if(self.currenPageView)
        {
            float scale = [self.currenPageView.myWebView getScaleFactorOfPageFit];
            int pageX = touchLocation.x / scale;
            pageX = pageX + (self.currenPageView.frame.size.width*[self.currenPageView.myWebView.webViewDAO getIndexOfPage]);
            int pageY = touchLocation.y ;
            NSString *jsFunc = [NSString stringWithFormat:@"triggerHighlight(%d,%d)",pageX,pageY];
            [self.currenPageView.myWebView stringByEvaluatingJavaScriptFromString:jsFunc];
        }
    }
}


- (void) removeAllSubViews:(UIView *) parentView
{
    
    NSArray *viewsToRemove = [parentView subviews];
    for (UIView *v in viewsToRemove) {
        
        [self destroyView:v];
    }
}

- (void)onPageOutOfRange
{
//    self.currenPageView = adjacentPrev;
//    adjacentPrev = [_delegate getPreviousPage:self.currenPageView];
//    adjacentPrev.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    [self addSubview: adjacentPrev];
//    
//    self.currenPageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    if(adjacentPrev)
//    {
//        adjacentPrev.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
//    }
//    if(adjacentNext)
//    {
//        adjacentNext.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
//    }
//    adjacentPrev = nil;
//    adjacentNext = nil;
//    [self checkAdjacentPagesLoaded];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(pendingPageAnimCompleted)
    {
        for (UITouch *touch in touches)
        {
            CGPoint touchLocation = [touch locationInView:self];
            startTouchPoint = touchLocation;
            offsetX = 0;
            offsetY = 0;
        }
        [self checkAdjacentPagesLoaded];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(pendingPageAnimCompleted)
    {
        for (UITouch *touch in touches)
        {
            CGPoint touchLocation = [touch locationInView:self];
            if(touchLocation.x<startTouchPoint.x)
            {
                //flipping to next page
                if(self.currenPageView)
                {
                    if(adjacentNext)
                    {
                        offsetX = -(startTouchPoint.x-touchLocation.x);
                        if(offsetX>=-self.frame.size.width)
                        {
                            self.currenPageView.frame = CGRectMake(offsetX, offsetY, self.frame.size.width, self.frame.size.height);
                            adjacentNext.frame = CGRectMake(offsetX+self.frame.size.width, offsetY, self.frame.size.width, self.frame.size.height);
                        }
                    }
                }
            }
            else if(touchLocation.x>startTouchPoint.x)
            {
                //flipping to previuos page
                if(self.currenPageView)
                {
                    if(adjacentPrev)
                    {
                        offsetX=(touchLocation.x-startTouchPoint.x);;
                        if(offsetX<=self.frame.size.width)
                        {
                            self.currenPageView.frame = CGRectMake(offsetX, offsetY, self.frame.size.width, self.frame.size.height);
                            adjacentPrev.frame = CGRectMake(offsetX-self.frame.size.width, offsetY, self.frame.size.width, self.frame.size.height);
                        }
                    }
                }
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(pendingPageAnimCompleted)
    {
        for (UITouch *touch in touches)
        {
            CGPoint touchLocation = [touch locationInView:self];
            endTouchPoint = touchLocation;
            
            if((startTouchPoint.x-endTouchPoint.x)>MIN_MOVE_TO_CHANGE_PAGE )
            {
                //flip success
                //moving forward direction
                if([_delegate getNextPage:self.currenPageView])
                {
                    //animate remaining page move
                    pendingPageAnimCompleted = NO;
                    [self performSelector:@selector(completeNextPageAnimation) withObject:self afterDelay:0.0 ];
                }
            }
            else if((endTouchPoint.x-startTouchPoint.x)>MIN_MOVE_TO_CHANGE_PAGE)
            {
                //moving backward direction
                if([_delegate getPreviousPage:self.currenPageView])
                {
                    //animate remaining page move
                    pendingPageAnimCompleted = NO;
                    [self performSelector:@selector(completePreviousPageAnimation) withObject:self afterDelay:0.0 ];
                }
            }
            else
            {
                //revert flip since not considered as successfull flip
                self.currenPageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                if(adjacentPrev)
                {
                    adjacentPrev.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                }
                if(adjacentNext)
                {
                    adjacentNext.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                }
            }
        }
    }
}

- (void) completeNextPageAnimation
{
    offsetX =offsetX - 5;
    if(ABS(offsetX)>=self.frame.size.width)
    {
        pendingPageAnimCompleted = YES;
    }
    else
    {
        self.currenPageView.frame = CGRectMake(offsetX, offsetY, self.frame.size.width, self.frame.size.height);
        adjacentNext.frame = CGRectMake(offsetX+self.frame.size.width, offsetY, self.frame.size.width, self.frame.size.height);
    }
    
    if(pendingPageAnimCompleted)
    {
        if(adjacentPrev)
        {
            [self destroyView:adjacentPrev];
        }
        adjacentPrev =self.currenPageView;
        self.currenPageView = adjacentNext;
        adjacentNext = [_delegate getNextPage:self.currenPageView];
        [self addSubview: adjacentNext];
        
        self.currenPageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        if(adjacentPrev)
        {
            adjacentPrev.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
        if(adjacentNext)
        {
            adjacentNext.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
        pendingPageAnimCompleted = YES;
        [self didPageFlipCompleted];
    }
    else
    {
        [self performSelector:@selector(completeNextPageAnimation) withObject:self afterDelay:0.0 ];
    }
}

- (void) completePreviousPageAnimation
{
    offsetX = offsetX + 5;
    if(ABS(offsetX)>=self.frame.size.width)
    {
        pendingPageAnimCompleted = YES;
    }
    else
    {
        self.currenPageView.frame = CGRectMake(offsetX, offsetY, self.frame.size.width, self.frame.size.height);
        adjacentPrev.frame = CGRectMake(offsetX-self.frame.size.width, offsetY, self.frame.size.width, self.frame.size.height);
    }
    
    
    if(pendingPageAnimCompleted)
    {
        if(adjacentNext)
        {
            [self destroyView:adjacentNext];
        }
        adjacentNext = self.currenPageView;
        self.currenPageView = adjacentPrev;
        adjacentPrev = [_delegate getPreviousPage:self.currenPageView];
        [self addSubview: adjacentPrev];
        
        self.currenPageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        if(adjacentPrev)
        {
            adjacentPrev.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
        if(adjacentNext)
        {
            adjacentNext.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
        [self didPageFlipCompleted];
    }
    else
    {
        [self performSelector:@selector(completePreviousPageAnimation) withObject:self afterDelay:0.0 ];
    }
}

- (void) settlePageWithAnim:(BOOL) shouldAnimate
{
    
}


- (void) destroyView:(UIView *) view
{
    [view removeFromSuperview];
}

- (void) refreshAdjacentPages
{
    if(adjacentNext)
    {
        MyPageView *mpv = (MyPageView *)adjacentNext;
        [mpv.myWebView updateFontSize];
    }
    if(adjacentPrev)
    {
        MyPageView *mpv = (MyPageView *)adjacentPrev;
        [mpv.myWebView updateFontSize];
    }
}

- (void) didPageFlipCompleted
{
    [_delegate didPageChange: self.currenPageView];
}

- (void) checkAdjacentPagesLoaded
{
    if(!adjacentNext)
    {
        adjacentNext = [_delegate getNextPage:self.currenPageView];
        if(adjacentNext)
        {
            [self addSubview: adjacentNext];
            adjacentNext.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
    }
    if(!adjacentPrev)
    {
        adjacentPrev = [_delegate getPreviousPage:self.currenPageView];
        if(adjacentPrev)
        {
            [self addSubview: adjacentPrev];
            adjacentPrev.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
    }
    if(self.currenPageView)
    {
        self.currenPageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
}


@end
