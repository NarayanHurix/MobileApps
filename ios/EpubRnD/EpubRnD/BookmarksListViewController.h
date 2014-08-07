//
//  BookmarksListViewController.h
//  EpubRnD
//
//  Created by UdaySravan K on 06/08/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkVO.h"
#import "PageVO.h"
#import "PageNavigationDelegate.h"
#import "Utils.h"

@interface BookmarksListViewController : UITableViewController<UITabBarControllerDelegate>

@property (nonatomic,weak) id<PageNavigationDelegate> delegateForPageNav;

- (void) refresh;

@end
