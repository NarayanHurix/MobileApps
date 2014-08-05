//
//  PageVO.m
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "PageVO.h"

@implementation PageVO

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

//- (void) setBookmarked:(BOOL) status
//{
//    isBookmarked = status;
//}
//- (BOOL) isBookmarked
//{
//    return isBookmarked;
//}

- (void)dealloc
{
    NSLog(@"my page view released");
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        mIndexOfPage = ((NSNumber *)[aDecoder decodeObjectForKey:@"IndexOfPage"]).integerValue;
        mIndexOfChapter = ((NSNumber *)[aDecoder decodeObjectForKey:@"IndexOfChapter"]).integerValue;
        firstWordID = ((NSNumber *)[aDecoder decodeObjectForKey:@"FirstWordID"]).integerValue;
        lastWordID = ((NSNumber *)[aDecoder decodeObjectForKey:@"LastWordID"]).integerValue;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInteger:mIndexOfPage]  forKey:@"IndexOfPage"];
    [aCoder encodeObject:[NSNumber numberWithInteger:mIndexOfChapter]  forKey:@"IndexOfChapter"];
    [aCoder encodeObject:[NSNumber numberWithInteger:firstWordID]  forKey:@"FirstWordID"];
    [aCoder encodeObject:[NSNumber numberWithInteger:lastWordID]  forKey:@"LastWordID"];
}
@end
