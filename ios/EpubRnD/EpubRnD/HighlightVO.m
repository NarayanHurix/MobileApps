//
//  HighlightVO.m
//  EpubRnD
//
//  Created by UdaySravan K on 17/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "HighlightVO.h"

@implementation HighlightVO

- (void) setChapterIndex:(int) indexOfChapter
{
    _chapterIndex = indexOfChapter;
}

- (int) getChapterIndex
{
    return _chapterIndex;
}

- (void) setNoOfPagesInChapter:(int) noOfPagesInChapter
{
    _noOfPagesInChapter = noOfPagesInChapter;
}
- (int) getNoOfPagesInChapter
{
    return _noOfPagesInChapter;
}

- (void) setStartWordID:(int) startWordID
{
    _startWordID = startWordID;
}
- (int) getStartWordID
{
    return _startWordID;
}

- (void) setEndWordID:(int) endWordID
{
    _endWordID = endWordID;
}
- (int) getEndWordID
{
    return _endWordID;
}
    
-(void)setHasNote:(BOOL)hasNote
{
    _hasNote = hasNote;
}
    
-(BOOL)hasNote
{
    return _hasNote;
}

@end
