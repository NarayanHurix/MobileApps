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
extern BOOL PEN_TOOL_SWITCH;
extern BOOL HIGHLIGHT_TOOL_SWITCH;
extern NSInteger EPUB_LAYOUT_TYPE;
+ (void) initSettings;

extern NSInteger STICKY_NOTE_ICON_WIDTH;
extern NSInteger STICKY_NOTE_ICON_HEIGHT;

@end
