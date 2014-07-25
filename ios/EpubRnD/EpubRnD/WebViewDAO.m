//
//  WebViewDAO.m
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "WebViewDAO.h"

@implementation WebViewDAO

- (void) setIndexOfPage:(NSInteger) indexOfPage
{
    mIndexOfPage = indexOfPage;
}

- (NSInteger) getIndexOfPage
{
    return mIndexOfPage;
}

- (void) setIndexOfChapter:(NSInteger) indexOfChapter
{
    mIndexOfChapter = indexOfChapter;
}

- (NSInteger) getIndexOfChapter
{
    return mIndexOfChapter;
}

- (void) setPageCount:(NSInteger) pageCount
{
    mPageCount = pageCount;
}

- (NSInteger) getPageCount
{
    return mPageCount;
}

- (void) setFirstWordID:(NSInteger) firstWordIDofPage
{
    firstWordID = firstWordIDofPage;
}
- (NSInteger) getFirstWordID
{
    return firstWordID ;
}
- (void) setLastWordID:(NSInteger) lastWordIDofPage
{
    lastWordID = lastWordIDofPage;
}
- (NSInteger) getLastWordID
{
    return lastWordID;
}

- (void) setBookmarked:(BOOL) status
{
    isBookmarked = status;
}
- (BOOL) isBookmarked
{
    return isBookmarked;
}

@end
