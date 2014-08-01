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
#import "BookmarkView.h"

@protocol MyWebViewDelegate<StickyNoteViewDelegate>

@required
- (void) myWebViewDidLoadFinish;
- (void) myWebViewBeganLoading;
- (void) myWebViewOnPageOutOfRange;
- (void) toggleHighlightSwitch;
- (void) changeBookMarkStatus:(BOOL) isBookmarked byUser:(BOOL) byUser;
- (void) disableBookmark:(BOOL) disable;
@end

@interface MyWebView : UIWebView<UIWebViewDelegate,UIPopoverControllerDelegate,StickyNoteViewDelegate,BookmarkViewDelegate>

@property (nonatomic,weak) id<MyWebViewDelegate> myDelegate;

@property (nonatomic,retain ) WebViewDAO *webViewDAO;
@property (nonatomic,retain ) StartStickView *startStick ;
@property (nonatomic,retain ) EndStickView *endStick;

@property (nonatomic,strong) HighlightVO *currHighlightVO;

- (void) loadViewWithData:(WebViewDAO *) data;
- (void) updateFontSize;
- (void) didHighlightButtonTap;
- (void) didTouchOnHighlightStick :(BOOL) isStartStick : (BOOL) isEndStick;
- (void) saveHighlight:(BOOL) hasNote;
- (void) closePopupAndClearHighlight;
- (float) getScaleFactorOfPageFit;
@end
