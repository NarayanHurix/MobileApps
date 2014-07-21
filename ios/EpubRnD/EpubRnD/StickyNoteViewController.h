//
//  StickyNoteViewController.h
//  EpubRnD
//
//  Created by UdaySravan K on 17/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighlightVO.h"

@class StickyNoteView;

@protocol StickyNoteViewControllerDelegate <NSObject>

@required

- (void) didCloseStickyNoteWindow;

@end

@interface StickyNoteViewController : UIViewController



- (IBAction)closeee:(id)sender;

@property (nonatomic,strong) HighlightVO *highlightVO;

@property (nonatomic,weak) id<StickyNoteViewControllerDelegate>  myDelegate;
- (IBAction)closeNoteEditor:(id)sender;

@end
