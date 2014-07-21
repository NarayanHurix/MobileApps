//
//  AppViewController.m
//  EpubWithPageController
//
//  Created by UdaySravan K on 21/04/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "AppViewController.h"
#import "GlobalConstants.h"
#import "GlobalSettings.h"
#import "ChapterVO.h"

@interface AppViewController ()
{
    NSMutableArray *chaptersColl;
}
@end

@implementation AppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [GlobalSettings initSettings];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [[NSBundle mainBundle] pathForResource:[myPVC.spines objectAtIndex:myPVC.currentSpineIndex]  ofType:@"xhtml" inDirectory:@"assets/cole-voyage-of-life-20120320/EPUB/xhtml"];
    
    
    chaptersColl = [NSMutableArray new];
    [self prepareChapterColl:chaptersColl];
    
    
//    ChapterVO *cV11 = [ChapterVO new];
//    cV11.chapterURL =@"nav";
//    [chaptersColl addObject:cV11];
    
//    [NSArray arrayWithObjects:@"0-intro",@"1a-childhood-text",@"1b-childhood-painting",@"2a-youth-text",@"2b-youth-painting",@"3a-manhood-text",@"3b-manhood-painting",@"4a-oldage-text",@"4b-oldage-painting",@"5-significance",@"nav", nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareChapterColl:(NSMutableArray *) coll
{
    ChapterVO *cVO1 = [ChapterVO new];
    cVO1.chapterURL =@"0-intro";
    [coll addObject:cVO1];
    
    ChapterVO *cVO2 = [ChapterVO new];
    cVO2.chapterURL =@"1a-childhood-text";
    [coll addObject:cVO2];
    
    ChapterVO *cVO3 = [ChapterVO new];
    cVO3.chapterURL =@"1b-childhood-painting";
    [coll addObject:cVO3];
    
    ChapterVO *cVO4 = [ChapterVO new];
    cVO4.chapterURL =@"2a-youth-text";
    [coll addObject:cVO4];
    
    ChapterVO *cVO5 = [ChapterVO new];
    cVO5.chapterURL =@"2b-youth-painting";
    [coll addObject:cVO5];
    
    ChapterVO *cVO6 = [ChapterVO new];
    cVO6.chapterURL =@"3a-manhood-text";
    [coll addObject:cVO6];
    
    ChapterVO *cVO7 = [ChapterVO new];
    cVO7.chapterURL =@"3b-manhood-painting";
    [coll addObject:cVO7];
    
    ChapterVO *cVO8 = [ChapterVO new];
    cVO8.chapterURL =@"4a-oldage-text";
    [coll addObject:cVO8];
    
    ChapterVO *cVO9 = [ChapterVO new];
    cVO9.chapterURL =@"4b-oldage-painting";
    [coll addObject:cVO9];
    
    ChapterVO *cV1O = [ChapterVO new];
    cV1O.chapterURL =@"5-significance";
    [coll addObject:cV1O];
}

- (void) prepareChapterColl2:(NSMutableArray *) coll
{
    ChapterVO *cVO1 = [ChapterVO new];
    cVO1.chapterURL =@"page0001";
    [coll addObject:cVO1];
    
    ChapterVO *cVO2 = [ChapterVO new];
    cVO2.chapterURL =@"page0002";
    [coll addObject:cVO2];
    
    ChapterVO *cVO3 = [ChapterVO new];
    cVO3.chapterURL =@"page0003";
    [coll addObject:cVO3];
    
    ChapterVO *cVO4 = [ChapterVO new];
    cVO4.chapterURL =@"page0004";
    [coll addObject:cVO4];
    
    ChapterVO *cVO5 = [ChapterVO new];
    cVO5.chapterURL =@"page0005";
    [coll addObject:cVO5];
    
    ChapterVO *cVO6 = [ChapterVO new];
    cVO6.chapterURL =@"page0006";
    [coll addObject:cVO6];
    
    ChapterVO *cVO7 = [ChapterVO new];
    cVO7.chapterURL =@"page0007";
    [coll addObject:cVO7];
    
    ChapterVO *cVO8 = [ChapterVO new];
    cVO8.chapterURL =@"page0008";
    [coll addObject:cVO8];
    
    ChapterVO *cVO9 = [ChapterVO new];
    cVO9.chapterURL =@"page0009";
    [coll addObject:cVO9];
    
    ChapterVO *cVO10 = [ChapterVO new];
    cVO10.chapterURL =@"page0010";
    [coll addObject:cVO10];

    ChapterVO *cVO11 = [ChapterVO new];
    cVO11.chapterURL =@"page0011";
    [coll addObject:cVO11];
    
    ChapterVO *cVO12 = [ChapterVO new];
    cVO12.chapterURL =@"page0012";
    [coll addObject:cVO12];
    
    ChapterVO *cVO13 = [ChapterVO new];
    cVO13.chapterURL =@"page0013";
    [coll addObject:cVO13];
    
    ChapterVO *cVO14 = [ChapterVO new];
    cVO14.chapterURL =@"page0014";
    [coll addObject:cVO14];
    
    ChapterVO *cVO15 = [ChapterVO new];
    cVO15.chapterURL =@"page0015";
    [coll addObject:cVO15];
    
    ChapterVO *cVO16 = [ChapterVO new];
    cVO16.chapterURL =@"page0016";
    [coll addObject:cVO16];
    
    ChapterVO *cVO17 = [ChapterVO new];
    cVO17.chapterURL =@"page0017";
    [coll addObject:cVO17];
    
    ChapterVO *cVO18 = [ChapterVO new];
    cVO18.chapterURL =@"page0018";
    [coll addObject:cVO18];
    
    ChapterVO *cVO19 = [ChapterVO new];
    cVO19.chapterURL =@"page0019";
    [coll addObject:cVO19];
    
    ChapterVO *cVO20 = [ChapterVO new];
    cVO20.chapterURL =@"page0020";
    [coll addObject:cVO20];
}

//! @private

- (IBAction)openBook:(id)sender
{
    [BookModelFactory sharedInstance].chaptersColl = chaptersColl;
    [BookModelFactory sharedInstance].pageCountInBook = 0;
    
    self.myPVC = [[MainViewController alloc] init];
    
    [[self.myPVC view] setFrame:[[self view] bounds]];
    [[self view]  addSubview:[self.myPVC view]];
    [[self view] bringSubviewToFront:[self.myPVC view]];
    
    [self.myPVC openBook];
}

@end
