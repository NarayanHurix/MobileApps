//
//  BookmarkView.h
//  EpubRnD
//
//  Created by UdaySravan K on 25/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookmarkViewDelegate <NSObject>

@required
- (void) didChangeBookmarkStatus:(BOOL) madeBookmark;

@end

@interface BookmarkView : UIView

@property (nonatomic,weak) id<BookmarkViewDelegate> myDelegate;
- (void) setBookmarkState:(BOOL) status;
@end
