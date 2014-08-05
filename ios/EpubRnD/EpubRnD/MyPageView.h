//
//  MyPageView.h
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWebView.h"
#import "PageVO.h"
#import "BookmarkView.h"
#import "GlobalConstants.h"

@interface MyPageView : UIView<MyWebViewDelegate>

@property (retain,nonatomic) MyWebView *myWebView;

@property (retain,nonatomic) UIActivityIndicatorView *activityIndicator;
@property (retain,nonatomic) UIView *touchHelperView ;

- (void) loadViewWithData:(PageVO *) data;

@property (retain,nonatomic) BookmarkView *bookmarkView;

@end
