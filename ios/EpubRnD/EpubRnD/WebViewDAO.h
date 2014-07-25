//
//  WebViewDAO.h
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChapterVO.h"

@interface WebViewDAO : NSObject
{
    NSInteger mIndexOfPage;
    NSInteger mIndexOfChapter;
    NSInteger mPageCount;
    NSInteger firstWordID;
    NSInteger lastWordID;
    BOOL isBookmarked;
}

@property (nonatomic,weak) ChapterVO *chapterVO;

- (void) setIndexOfPage:(NSInteger) indexOfPage;
- (NSInteger) getIndexOfPage;
- (void) setIndexOfChapter:(NSInteger) indexOfChapter;
- (NSInteger) getIndexOfChapter;
- (void) setPageCount:(NSInteger) pageCount;
- (NSInteger) getPageCount;
- (void) setFirstWordID:(NSInteger) firstWordIDofPage;
- (NSInteger) getFirstWordID;
- (void) setLastWordID:(NSInteger) lastWordIDofPage;
- (NSInteger) getLastWordID;
- (void) setBookmarked:(BOOL) status;
- (BOOL) isBookmarked;



@end
