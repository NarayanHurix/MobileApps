//
//  MyViewPager.h
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MyViewPagerDelegate <NSObject>

@required
- (UIView *) getPreviousPage:(UIView*) oldPageView;
- (UIView *) getNextPage:(UIView*) oldPageView;
@end

@interface MyViewPager : UIView

@property (nonatomic,strong) UIViewController *mainController;
@property (nonatomic,strong) id<MyViewPagerDelegate> delegate;
@property (nonatomic,strong) UIView *currenPageView;

- (void) initWithPageView:(UIView *) view;
- (void) onPageOutOfRange;
- (void) refreshAdjucentPages;
@end
