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
@end

@interface MyViewPager : UIView

@property (nonatomic,strong) UIViewController *mainController;
@property (nonatomic,strong) id<MyViewPagerDelegate> delegate;
@property (nonatomic,strong) MyPageView *currenPageView;

- (void) initWithPageView:(MyPageView *) view;
- (void) onPageOutOfRange;
- (void) refreshAdjacentPages;
@end
