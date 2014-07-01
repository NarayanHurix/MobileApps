//
//  StartStickView.m
//  EpubRnD
//
//  Created by UdaySravan K on 01/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "StartStickView.h"
#import "MyWebView.h"

@implementation StartStickView

@synthesize myWebView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    [myWebView didTouchOnHighlightStick:YES :NO];
}

@end
