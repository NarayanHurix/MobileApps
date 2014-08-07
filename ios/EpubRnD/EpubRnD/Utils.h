//
//  Utils.h
//  EpubRnD
//
//  Created by UdaySravan K on 06/08/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookModelFactory.h"
#import "PageVO.h"
#import "GlobalConstants.h"

@interface Utils : NSObject

+ (PageVO *) getPageVO:(int) pageNo;
+ (int) getPageNoFromPageVO:(PageVO *) vo;
+ (PageVO *) getPageVOUsing:(int) indexOfChapter andWordID:(int) wordID;

@end
