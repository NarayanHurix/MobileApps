//
//  ContentsView.h
//  EpubRnD
//
//  Created by UdaySravan K on 06/08/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentsTabBarController.h"
#import "BookmarksListViewController.h"
#import "NotesListViewController.h"
#import "HighlightsListViewController.h"

@class MainViewController;

@interface ContentsView : UIView

@property (nonatomic,strong) MainViewController *mainViewController;

@property (nonatomic,strong) ContentsTabBarController *tabBarController;

@property (nonatomic,strong) BookmarksListViewController *bookmarksListVC;
@property (nonatomic,strong) NotesListViewController *notesListVC;
@property (nonatomic,strong) HighlightsListViewController *highlightsListVC;
- (void) prepareTabs;
- (void) refresh;
@end
