//
//  Utils.m
//  EpubRnD
//
//  Created by UdaySravan K on 06/08/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "Utils.h"


@implementation Utils


+ (PageVO *) getPageVO:(int) pageNo
{
    int arrLength = [[BookModelFactory sharedInstance] chaptersColl].count;
    int tempPageCount = 0;
    for (int i=0; i<arrLength; i++)
    {
        ChapterVO *tempCVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:i];
        tempPageCount+= tempCVO.pageCountInChapter;
        if(pageNo<=tempPageCount)
        {
            PageVO *vo = [[PageVO alloc] init];
            [vo setIndexOfChapter:i];
            [vo setIndexOfPage:(pageNo - (tempPageCount-tempCVO.pageCountInChapter))-1];
            return vo;
        }
    }
    
    return Nil;
}

+ (int) getPageNoFromPageVO:(PageVO *) vo
{
    int arrLength = [[BookModelFactory sharedInstance] chaptersColl].count;
    int tempPageCount = 0;
    for (int i=0; i<arrLength; i++)
    {
        ChapterVO *tempCVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:i];
        tempPageCount+= tempCVO.pageCountInChapter;
        if(i == [vo getIndexOfChapter])
        {
            return tempPageCount-tempCVO.pageCountInChapter+([vo getIndexOfPage]+1);
        }
    }
    return -1;
}

+ (PageVO *) getPageVOUsing:(int) indexOfChapter andWordID:(int) wordID
{
    
    ChapterVO *tempCVO = [[[BookModelFactory sharedInstance] chaptersColl] objectAtIndex:indexOfChapter];
    
    PageVO *vo = [[PageVO alloc] init];
    [vo setChapterVO:tempCVO];
    [vo setIndexOfChapter:indexOfChapter];
    [vo setIndexOfPage:GET_PAGE_INDEX_USING_WORD_ID];
    [vo setWordIDToGetIndexOfPage:wordID];
    return vo;
    
}

@end
