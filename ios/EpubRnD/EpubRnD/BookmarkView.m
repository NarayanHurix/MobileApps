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
    UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
        [singleTapGesture setNumberOfTouchesRequired:1];
        [singleTapGesture setNumberOfTapsRequired:1];
        [self addGestureRecognizer:singleTapGesture];
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        imageView = [[UIImageView alloc] initWithFrame:rect];
        [self addSubview:imageView];
        [self changeBookMarkStatus:NO byUser:NO];
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
    UIImage *image = nil;
    if(self->isBookmarked)
    {
        image = [UIImage imageNamed:@"bookmarkbutton_selected.png"];
        //self.backgroundColor = [UIColor colorWithRed:0.3 green:0.8 blue:0.9 alpha:1];
    }
    else
    {
        image = [UIImage imageNamed:@"bookmark.png"];
        //self.backgroundColor = [UIColor grayColor];
    }
    [imageView setImage:image];
    [self.myDelegate didChangeBookmarkStatus:self->isBookmarked :byUser];
}



@end
