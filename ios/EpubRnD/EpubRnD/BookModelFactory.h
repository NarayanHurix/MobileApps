//
//  BookModelFactory.h
//  EpubRnD
//
//  Created by UdaySravan K on 10/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModelFactory : NSObject

+ (BookModelFactory *) sharedInstance;

@property (nonatomic,weak) NSMutableArray *chaptersColl;

@property (nonatomic,readwrite)  NSInteger pageCountInBook;

@end
