//
//  BookmarkVO.h
//  EpubRnD
//
//  Created by UdaySravan K on 25/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookmarkVO : NSObject
{
    @public;
        NSInteger indexOfChapter;
        NSInteger bookmarkedWordID;
}

@property (nonatomic,strong) NSString *bookmarkID;//managed object id uri representation
@property (nonatomic,strong) NSString *bookmarkText;


@end