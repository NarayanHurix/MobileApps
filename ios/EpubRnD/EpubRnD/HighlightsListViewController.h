//
//  HighlightsListViewController.h
//  EpubRnD
//
//  Created by UdaySravan K on 06/08/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighlightVO.h"
#import "Utils.h"
#import "PageNavigationDelegate.h"

@class PageVO;

@interface HighlightsListViewController : UITableViewController

@property (nonatomic,weak) id<PageNavigationDelegate> delegateForPageNav;
- (void) refresh;
@end
