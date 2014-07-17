//
//  HighlightPopupViewController.h
//  EpubRnD
//
//  Created by UdaySravan K on 01/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWebView.h"

@interface HighlightPopupViewController : UIViewController
- (IBAction)didClickOnSave:(id)sender;

@property (nonatomic,retain) MyWebView *myWebView;
- (IBAction)Close:(id)sender;
- (IBAction)addStickyNote:(UIButton *)sender;

@end
