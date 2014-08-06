//
//  PageVO.h
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChapterVO.h"
#import "BookmarkVO.h"

@interface PageVO : NSObject <NSCoding>
{
    NSInteger mIndexOfPage;
    NSInteger mIndexOfChapter;
    NSInteger firstWordID;
    NSInteger lastWordID;
    NSInteger wordIDToGetIndexOfPage;
}

@property (nonatomic,weak) ChapterVO *chapterVO;

- (void) setIndexOfPage:(NSInteger) indexOfPage;
- (NSInteger) getIndexOfPage;
- (void) setIndexOfChapter:(NSInteger) indexOfChapter;
- (NSInteger) getIndexOfChapter;
- (void) setFirstWordID:(NSInteger) firstWordIDofPage;
- (NSInteger) getFirstWordID;
- (void) setLastWordID:(NSInteger) lastWordIDofPage;
- (NSInteger) getLastWordID;
- (void) setWordIDToGetIndexOfPage:(NSInteger) wordID;
- (NSInteger) getWordIDToGetIndexOfPage;

@end
