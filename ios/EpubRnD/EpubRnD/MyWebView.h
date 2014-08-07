//
//  MyWebView.h
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageVO.h"
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
- (void) switchContentsLayout:(BOOL) hide;
- (void) disableBookmark:(BOOL) disable;
@end

@interface MyWebView : UIWebView<UIWebViewDelegate,UIPopoverControllerDelegate,StickyNoteViewDelegate,BookmarkViewDelegate>

@property (nonatomic,weak) id<MyWebViewDelegate> myDelegate;

@property (nonatomic,retain ) PageVO *pageVO;
@property (nonatomic,retain ) StartStickView *startStick ;
@property (nonatomic,retain ) EndStickView *endStick;

@property (nonatomic,strong) HighlightVO *currHighlightVO;

- (void) loadViewWithData:(PageVO *) data;
- (void) updateFontSize;
- (void) didHighlightButtonTap;
- (void) didTouchOnHighlightStick :(BOOL) isStartStick : (BOOL) isEndStick;
- (void) saveHighlight:(BOOL) hasNote;
- (void) closePopupAndClearHighlight;
- (float) getScaleFactorOfPageFit;

@end
