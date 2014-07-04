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
{
    CGPoint startTouchPoint ,endTouchPoint;
    UIView *adjucentNext,*adjucentPrev;
    int offsetX,offsetY;
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
    pendingPageAnimCompleted = YES;
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
        UIView *previousPage = [_delegate getPreviousPage:oldPage];
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
        
        [self destroyView:v];
    }
}

- (void)onPageOutOfRange
{
    [self onSwipeRight:nil];
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
        if(!adjucentNext)
        {
            adjucentNext = [_delegate getNextPage:self.currenPageView];
            if(adjucentNext)
            {
                [self addSubview: adjucentNext];
                
                self.currenPageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                
                adjucentNext.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                
            }
        }
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
                    if(adjucentNext)
                    {
                        offsetX = -(startTouchPoint.x-touchLocation.x);
                        if(offsetX>=-self.frame.size.width)
                        {
                            self.currenPageView.frame = CGRectMake(offsetX, offsetY, self.frame.size.width, self.frame.size.height);
                            adjucentNext.frame = CGRectMake(offsetX+self.frame.size.width, offsetY, self.frame.size.width, self.frame.size.height);
                        }
                    }
                }
            }
            else if(touchLocation.x>startTouchPoint.x)
            {
                //flipping to previuos page
                if(self.currenPageView)
                {
                    if(adjucentPrev)
                    {
                        offsetX=(touchLocation.x-startTouchPoint.x);;
                        if(offsetX<=self.frame.size.width)
                        {
                            self.currenPageView.frame = CGRectMake(offsetX, offsetY, self.frame.size.width, self.frame.size.height);
                            adjucentPrev.frame = CGRectMake(offsetX-self.frame.size.width, offsetY, self.frame.size.width, self.frame.size.height);
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
            
            if((startTouchPoint.x-endTouchPoint.x)>30 )
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
            else if((endTouchPoint.x-startTouchPoint.x)>30)
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
                if(adjucentPrev)
                {
                    adjucentPrev.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                }
                if(adjucentNext)
                {
                    adjucentNext.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
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
        adjucentNext.frame = CGRectMake(offsetX+self.frame.size.width, offsetY, self.frame.size.width, self.frame.size.height);
    }
    
    if(pendingPageAnimCompleted)
    {
        if(adjucentPrev)
        {
            [self destroyView:adjucentPrev];
        }
        adjucentPrev =self.currenPageView;
        self.currenPageView = adjucentNext;
        adjucentNext = [_delegate getNextPage:self.currenPageView];
        [self addSubview: adjucentNext];
        
        self.currenPageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        if(adjucentPrev)
        {
            adjucentPrev.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
        if(adjucentNext)
        {
            adjucentNext.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
        pendingPageAnimCompleted = YES;
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
        adjucentPrev.frame = CGRectMake(offsetX-self.frame.size.width, offsetY, self.frame.size.width, self.frame.size.height);
    }
    
    
    if(pendingPageAnimCompleted)
    {
        if(adjucentNext)
        {
            [self destroyView:adjucentNext];
        }
        adjucentNext = self.currenPageView;
        self.currenPageView = adjucentPrev;
        adjucentPrev = [_delegate getPreviousPage:self.currenPageView];
        [self addSubview: adjucentPrev];
        
        self.currenPageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        if(adjucentPrev)
        {
            adjucentPrev.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
        if(adjucentNext)
        {
            adjucentNext.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
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

@end
