//
//  MyPageView.h
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWebView.h"
#import "WebViewDAO.h"
#import "AssetsContainer.h"
#import "BookmarkView.h"
#import "GlobalConstants.h"

@interface MyPageView : UIView<MyWebViewDelegate>

@property (nonatomic,retain) MyWebView *myWebView;
@property (nonatomic,weak) AssetsContainer *assetsContainer;

@property (nonatomic,retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,retain) UIView *touchHelperView ;

- (void) loadViewWithData:(WebViewDAO *) data;

@property (nonatomic,retain) BookmarkView *bookmarkView;


@end
