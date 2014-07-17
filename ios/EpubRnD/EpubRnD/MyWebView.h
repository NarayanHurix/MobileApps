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
#import "HighlightVO.h"
#import "StickyNoteView.h"

@protocol MyWebViewDelegate<NSObject>

@required
- (void) myWebViewDidLoadFinish;
- (void) myWebViewBeganLoading;
- (void) myWebViewOnPageOutOfRange;
- (void) toggleHighlightSwitch;
@end

@interface MyWebView : UIWebView<UIWebViewDelegate,UIPopoverControllerDelegate>

@property (nonatomic,weak) id<MyWebViewDelegate> myDelegate;

@property (nonatomic,retain ) WebViewDAO *webViewDAO;
@property (nonatomic,retain ) StartStickView *startStick ;
@property (nonatomic,retain ) EndStickView *endStick;

@property (nonatomic,strong) HighlightVO *currHighlightVO;

- (void) loadViewWithData:(WebViewDAO *) data;
- (void) updateFontSize;
- (void) didHighlightButtonTap;
- (void) didTouchOnHighlightStick :(BOOL) isStartStick : (BOOL) isEndStick;
- (void) saveHighlight;
- (void) closePopupAndClearHighlight;
- (void) addNoteAndClosePopup;
@end
