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
#import "HelperViewForPageCount.h"
#import "BookModelFactory.h"
#import "Utils.h"
#import "ContentsView.h"
#import "PageNavigationDelegate.h"


@interface MainViewController : UIViewController<MyViewPagerDelegate,ComputePageCountInBookDelgate,PageNavigationDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pageNoLable;

@property (weak, nonatomic) IBOutlet MyViewPager *myViewPager;
- (IBAction)closeBook:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *bookLoadingIndicatorView;

- (IBAction)decreaseFontSize:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet HelperViewForPageCount *helperForPageCount;

- (IBAction)increaseFontSize:(UIButton *)sender;
//- (void)onPageOutOfRange;
- (IBAction)penToolEnable:(UIButton *)sender;
- (IBAction)onTapHighlightBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *highlightBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnFontIncrease;
@property (weak, nonatomic) IBOutlet UIButton *btnFontDecrease;
- (IBAction)didSliderValueChange:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UISlider *pageNavSlider;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *bookLoadActInd;
- (void) didPageChange:(PageVO *) dao;
@property (nonatomic,strong) PageVO *currentPageData;
- (void) toggleHighlightSwitch;
- (IBAction)toggleDataBankLayout:(id)sender;
@property (weak, nonatomic) IBOutlet ContentsView *contentsView;


- (void) didOpenNoteEditor;
- (void) didCloseNoteEditor;

/*!
 * /p
 */
- (void) openBook;
- (void) switchContentsLayout:(BOOL) hide;
@end
