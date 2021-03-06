//
//  Constants.h
//  EpubRnD
//
//  Created by UdaySravan K on 11/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalConstants : NSObject

extern NSInteger const MAX_FONT_SIZE ;
extern NSInteger const MIN_FONT_SIZE ;
extern NSInteger const FONT_SIZE_STEP_SIZE ;

extern NSInteger const REFLOWABLE ;
extern NSInteger const FIXED;

extern NSInteger const DEFAULT_STICKYNOTE_WIDTH;
extern NSInteger const DEFAULT_STICKYNOTE_HEIGHT;

extern NSInteger const DEFAULT_BOOKMARK_WIDTH;
extern NSInteger const DEFAULT_BOOKMARK_HEIGHT;

extern NSString *const CHAPTERS_FOLDER_PATH;

extern NSInteger const PAGE_INDEX_GREATER_THAN_PAGE_COUNT;
extern NSInteger const GET_PAGE_INDEX_USING_WORD_ID;

@end
