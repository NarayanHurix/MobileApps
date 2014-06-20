//
//  GlobalSettings.m
//  EpubRnD
//
//  Created by UdaySravan K on 11/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "GlobalSettings.h"
#import "GlobalConstants.h"

@implementation GlobalSettings

NSInteger CURRENT_FONT_SIZE;
BOOL PEN_TOOL_ENABLE;

+ (void) initSettings
{
    CURRENT_FONT_SIZE = MIN_FONT_SIZE;
    PEN_TOOL_ENABLE = NO;
}


@end
