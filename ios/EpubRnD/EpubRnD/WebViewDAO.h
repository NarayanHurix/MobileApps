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
}

@property (nonatomic,weak) ChapterVO *chapterVO;

- (void) setIndexOfPage:(NSInteger) indexOfPage;
- (NSInteger) getIndexOfPage;
- (void) setIndexOfChapter:(NSInteger) indexOfChapter;
- (NSInteger) getIndexOfChapter;
- (void) setPageCount:(NSInteger) pageCount;
- (NSInteger) getPageCount;


@end
