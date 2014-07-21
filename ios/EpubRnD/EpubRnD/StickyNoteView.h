//
//  StickyNoteView.h
//  EpubRnD
//
//  Created by UdaySravan K on 17/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighlightVO.h"
#import "StickyNoteViewController.h"


@protocol StickyNoteViewDelegate <NSObject>

- (void) didOpenNoteEditor;
- (void) didCloseNoteEditor;

@end

@interface StickyNoteView : UIView<StickyNoteViewControllerDelegate>

@property (nonatomic,strong) HighlightVO *highlightVO;

@property (nonatomic, weak) id<StickyNoteViewDelegate> myDelegate;

@end
