//
//  Constants.m
//  EpubRnD
//
//  Created by UdaySravan K on 11/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "GlobalConstants.h"



@implementation GlobalConstants

NSInteger const MAX_FONT_SIZE = 178;
NSInteger const MIN_FONT_SIZE = 150;
NSInteger const FONT_SIZE_STEP_SIZE = 4;

//EPUB type
NSInteger const REFLOWABLE = 100;
NSInteger const FIXED = 200;

NSInteger const DEFAULT_STICKYNOTE_WIDTH = 40;
NSInteger const DEFAULT_STICKYNOTE_HEIGHT = 40;

NSInteger const DEFAULT_BOOKMARK_WIDTH = 30;
NSInteger const DEFAULT_BOOKMARK_HEIGHT = 60;

NSInteger const PAGE_INDEX_GREATER_THAN_PAGE_COUNT = -2;

NSInteger const GET_PAGE_INDEX_USING_WORD_ID = -3;

NSString *const CHAPTERS_FOLDER_PATH = @"assets/cole-voyage-of-life-20120320/EPUB/xhtml";
//NSString *const CHAPTERS_FOLDER_PATH = @"assets/3920131231111/OPS";
@end
