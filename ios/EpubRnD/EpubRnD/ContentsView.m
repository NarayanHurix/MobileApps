//
//  ContentsView.m
//  EpubRnD
//
//  Created by UdaySravan K on 06/08/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "ContentsView.h"
#import "MainViewController.h"

@implementation ContentsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void) initialize
{
    self.tabBarController = [[ContentsTabBarController alloc] init];
    self.tabBarController.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:self.tabBarController.view];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) prepareTabs
{
    self.bookmarksListVC = [[BookmarksListViewController alloc] init];
    self.bookmarksListVC.delegateForPageNav = self.mainViewController;
    self.bookmarksListVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Bookmarks" image:[UIImage imageNamed:@"sticky_note.png"] tag:100];
    
//    self.notesListVC = [[NotesListViewController alloc] init];
//    self.notesListVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Notes" image:[UIImage imageNamed:@"sticky_note.png"] tag:200];
    
    self.highlightsListVC = [[HighlightsListViewController alloc] init];
    self.highlightsListVC.delegateForPageNav = self.mainViewController;
    self.highlightsListVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Highlights" image:[UIImage imageNamed:@"sticky_note.png"] tag:300];
    
    self.tabBarController.viewControllers = @[self.bookmarksListVC,self.highlightsListVC];
    
}

- (void) refresh
{
    if(self.bookmarksListVC)
    {
        [self.bookmarksListVC refresh];
    }
    
    if(self.notesListVC)
    {
        [self.notesListVC refresh];
    }
    
    if(self.highlightsListVC)
    {
        [self.highlightsListVC refresh];
    }
}

@end
