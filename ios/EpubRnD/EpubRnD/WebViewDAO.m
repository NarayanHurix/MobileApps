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

@end
