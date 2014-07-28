//
//  BookmarkView.m
//  EpubRnD
//
//  Created by UdaySravan K on 25/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "BookmarkView.h"
@class BookmarkVO;
@class ABC;

@implementation BookmarkView
{
    BOOL isBookmarked;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
        [singleTapGesture setNumberOfTouchesRequired:1];
        [singleTapGesture setNumberOfTapsRequired:1];
        [self addGestureRecognizer:singleTapGesture];
        
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

- (void) onSingleTap:(UIGestureRecognizer *) recognizer
{
    [self changeBookMarkStatus:!isBookmarked byUser:YES];
}

- (void) changeBookMarkStatus:(BOOL) status byUser:(BOOL) byUser
{
    self->isBookmarked = status;
    
    if(self->isBookmarked)
    {
        self.backgroundColor = [UIColor purpleColor];
    }
    else
    {
        self.backgroundColor = [UIColor grayColor];
    }
    [self.myDelegate didChangeBookmarkStatus:self->isBookmarked :byUser];
}



@end
