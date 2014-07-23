//
//  StickyNoteView.m
//  EpubRnD
//
//  Created by UdaySravan K on 17/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "StickyNoteView.h"

@implementation StickyNoteView
{
    StickyNoteViewController *contrller;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];

        [singleTapGesture setNumberOfTapsRequired:1];
        [singleTapGesture setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:singleTapGesture];
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
        
        [doubleTapGesture setNumberOfTapsRequired:2];
        [doubleTapGesture setNumberOfTouchesRequired:2];
        [self addGestureRecognizer:doubleTapGesture];
        
        [self setBackgroundColor:[UIColor brownColor ]];
        //[self setImage:[UIImage imageNamed:@"sticky_note.png"]];
        
    }
    return self;
}

- (void) onSingleTap:(UIGestureRecognizer *) recognizer
{
    [self.myDelegate didOpenNoteEditor];
    
    
    contrller = [[StickyNoteViewController alloc] init];
    contrller.myDelegate = self;
    contrller.highlightVO = self.highlightVO;
    [self.superview addSubview:contrller.view];
}

- (void) onDoubleTap:(UIGestureRecognizer *) recognizer
{
    
}

- (void)didCloseStickyNoteWindow
{
    [self.myDelegate didCloseNoteEditor];
   
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
