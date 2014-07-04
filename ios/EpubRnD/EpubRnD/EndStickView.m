//
//  EndStickView.m
//  EpubRnD
//
//  Created by UdaySravan K on 01/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "EndStickView.h"
#import "MyWebView.h"

@implementation EndStickView
@synthesize myWebView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.5 alpha:1]];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [myWebView didTouchOnHighlightStick:NO :YES];
}

@end
