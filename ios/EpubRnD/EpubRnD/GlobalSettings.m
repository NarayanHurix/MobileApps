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

NSInteger CURRENT_FONT_SIZE,EPUB_LAYOUT_TYPE;
BOOL PEN_TOOL_SWITCH;
BOOL HIGHLIGHT_TOOL_SWITCH;
BOOL CONTENTS_VIEW_HIDDEN;
NSInteger STICKY_NOTE_ICON_WIDTH,STICKY_NOTE_ICON_HEIGHT;

+ (void) initSettings
{
    CURRENT_FONT_SIZE = MIN_FONT_SIZE;
    PEN_TOOL_SWITCH = NO;
    HIGHLIGHT_TOOL_SWITCH = NO;
    CONTENTS_VIEW_HIDDEN = YES;
    EPUB_LAYOUT_TYPE = REFLOWABLE;
    STICKY_NOTE_ICON_WIDTH = DEFAULT_STICKYNOTE_WIDTH;
    STICKY_NOTE_ICON_HEIGHT = DEFAULT_STICKYNOTE_HEIGHT;
}


@end
