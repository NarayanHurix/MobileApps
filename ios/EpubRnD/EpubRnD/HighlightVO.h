//
//  HighlightVO.h
//  EpubRnD
//
//  Created by UdaySravan K on 17/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighlightVO : NSObject
{
    NSInteger _chapterIndex;
    NSInteger _noOfPagesInChapter;
    NSInteger _startWordID;
    NSInteger _endWordID;
    NSInteger _id;
    
}
@property (nonatomic,strong) NSString *moidURIRepresentationString;

@property (nonatomic,strong) NSString *chapterPath;
@property (nonatomic,strong) NSString *selectedText;

- (void) setChapterIndex:(int) indexOfChapter;
- (int) getChapterIndex;

- (void) setNoOfPagesInChapter:(int) noOfPagesInChapter;
- (int) getNoOfPagesInChapter;

- (void) setStartWordID:(int) startWordID;
- (int) getStartWordID;

- (void) setEndWordID:(int) endWordID;
- (int) getEndWordID;

@end
