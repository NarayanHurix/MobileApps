//
//  BookModelFactory.m
//  EpubRnD
//
//  Created by UdaySravan K on 10/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "BookModelFactory.h"

@implementation BookModelFactory

static BookModelFactory *shared;

+ (BookModelFactory *) sharedInstance
{
    static dispatch_once_t pred;
    if(!shared)
    {
        dispatch_once(&pred,^{
            
            shared = [[BookModelFactory alloc] init];
            
        });
    }
    
    return shared;
}

@end
