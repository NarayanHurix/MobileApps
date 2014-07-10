//
//  HelperViewForPageCount.h
//  EpubRnD
//
//  Created by UdaySravan K on 09/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModelFactory.h";

@protocol ComputePageCountInBookDelgate <NSObject>

@required

-(void) didCompletePageCounting:(int) count;

@end
@interface HelperViewForPageCount : UIWebView<UIWebViewDelegate>

- (void) startPageCounting:(id<ComputePageCountInBookDelgate>) delegate;

@end
