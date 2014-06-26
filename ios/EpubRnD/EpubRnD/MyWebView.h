//
//  MyWebView.h
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewDAO.h"

@protocol MyWebViewDelegate<NSObject>

@required
- (void) myWebViewDidLoadFinish;
- (void) myWebViewBeganLoading;
- (void) myWebViewOnPageOutOfRange;

@end

@interface MyWebView : UIWebView<UIWebViewDelegate>

@property (nonatomic,strong) id<MyWebViewDelegate> myDelegate;

@property (nonatomic,strong ) WebViewDAO *webViewDAO;

- (void) loadViewWithData:(WebViewDAO *) data;
- (void) updateFontSize;
- (void) didHighlightButtonTap;

@end
