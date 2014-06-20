//
//  GlobalSettings.h
//  EpubRnD
//
//  Created by UdaySravan K on 11/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"

@interface GlobalSettings : NSObject

extern NSInteger CURRENT_FONT_SIZE;
extern BOOL PEN_TOOL_ENABLE;
+ (void) initSettings;

@end
