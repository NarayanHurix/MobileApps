//
//  MyWebView.h
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewDAO.h"
#import "StartStickView.h"
#import "EndStickView.h"

@protocol MyWebViewDelegate<NSObject>

@required
- (void) myWebViewDidLoadFinish;
- (void) myWebViewBeganLoading;
- (void) myWebViewOnPageOutOfRange;

@end

@interface MyWebView : UIWebView<UIWebViewDelegate,UIPopoverControllerDelegate>

@property (nonatomic,strong) id<MyWebViewDelegate> myDelegate;

@property (nonatomic,strong ) WebViewDAO *webViewDAO;
@property (nonatomic,strong ) StartStickView *startStick ;
@property (nonatomic,strong ) EndStickView *endStick;

- (void) loadViewWithData:(WebViewDAO *) data;
- (void) updateFontSize;
- (void) didHighlightButtonTap;
- (void) didTouchOnHighlightStick :(BOOL) isStartStick : (BOOL) isEndStick;
- (void) saveHighlight;
- (void) closePopupAndClearHighlight;
@end
