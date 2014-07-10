//
//  ChapterVO.h
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChapterVO : NSObject

@property (nonatomic,strong) NSString *chapterURL;
@property (nonatomic,readwrite) NSInteger pageCountInChapter;

@end
