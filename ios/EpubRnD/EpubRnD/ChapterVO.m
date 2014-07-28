//
//  ChapterVO.m
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "ChapterVO.h"

@implementation ChapterVO

- (id) init
{
    self = [super init];
    if(self)
    {
        //object created successfully
        self.bookmarksColl = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
