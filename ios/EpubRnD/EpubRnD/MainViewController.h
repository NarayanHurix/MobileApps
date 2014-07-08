//
//  MainViewController.h
//  EpubRnD
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewPager.h"
#import "ChapterVO.h"
#import "MyWebView.h"

@interface MainViewController : UIViewController<MyViewPagerDelegate>

@property (weak, nonatomic) IBOutlet MyViewPager *myViewPager;
- (IBAction)closeBook:(UIButton *)sender;

- (IBAction)decreaseFontSize:(UIButton *)sender;

- (IBAction)increaseFontSize:(UIButton *)sender;
//- (void)onPageOutOfRange;
- (IBAction)penToolEnable:(UIButton *)sender;
- (IBAction)onTapHighlightBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnFontIncrease;
@property (weak, nonatomic) IBOutlet UIButton *btnFontDecrease;

@property (nonatomic,strong) NSArray *data;

/*!
 * /p
 */
- (void) setBookData:(NSArray *) data;

@end
