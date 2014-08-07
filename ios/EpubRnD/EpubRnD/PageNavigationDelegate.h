//
//  PageNavigationDelegate.h
//  EpubRnD
//
//  Created by UdaySravan K on 06/08/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageVO.h"

@protocol PageNavigationDelegate <NSObject>

@required
- (void) navigateToPage:(PageVO *) pageVO;

@end
