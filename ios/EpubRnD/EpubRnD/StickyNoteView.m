//
//  StickyNoteView.m
//  EpubRnD
//
//  Created by UdaySravan K on 17/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "StickyNoteView.h"

@implementation StickyNoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
        singleTapGesture.numberOfTapsRequired =1 ;
        [self addGestureRecognizer:singleTapGesture];
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired =1 ;
        [self addGestureRecognizer:doubleTapGesture];
        [self setImage:[UIImage imageNamed:@"sticky_note.png"]];
        
    }
    return self;
}



- (void) onSingleTap:(UIGestureRecognizer *) recognizer
{
    StickyNoteViewController *contrller = [[StickyNoteViewController alloc] init];
    [self.superview addSubview:contrller.view];
}

- (void) onDoubleTap:(UIGestureRecognizer *) recognizer
{
    
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
