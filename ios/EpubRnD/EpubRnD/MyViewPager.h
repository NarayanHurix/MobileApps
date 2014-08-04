//
//  MyViewPager.h
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPageView.h"

@protocol MyViewPagerDelegate <NSObject>

@required
- (MyPageView *) getPreviousPage:(MyPageView*) oldPageView;
- (MyPageView *) getNextPage:(MyPageView*) oldPageView;
- (void) didPageChange:(MyPageView *) currentPageView;
- (void) toggleHighlightSwitch;
@end

@interface MyViewPager : UIView

@property (nonatomic,retain) UIViewController *mainController;
@property (nonatomic,weak) id<MyViewPagerDelegate> delegate;


- (void) initWithPageView:(MyPageView *) view;
- (void) onPageOutOfRange;
- (void) refreshAdjacentPages;
- (MyPageView *) getCurrentPageView;
@end
