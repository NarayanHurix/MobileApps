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
    
    ChapterVO *cVO1 = [ChapterVO new];
    cVO1.chapterURL =@"0-intro";
    [chaptersColl addObject:cVO1];
    
    ChapterVO *cVO2 = [ChapterVO new];
    cVO2.chapterURL =@"1a-childhood-text";
    [chaptersColl addObject:cVO2];
    
    ChapterVO *cVO3 = [ChapterVO new];
    cVO3.chapterURL =@"1b-childhood-painting";
    [chaptersColl addObject:cVO3];
    
    ChapterVO *cVO4 = [ChapterVO new];
    cVO4.chapterURL =@"2a-youth-text";
    [chaptersColl addObject:cVO4];
    
    ChapterVO *cVO5 = [ChapterVO new];
    cVO5.chapterURL =@"2b-youth-painting";
    [chaptersColl addObject:cVO5];
    
    ChapterVO *cVO6 = [ChapterVO new];
    cVO6.chapterURL =@"3a-manhood-text";
    [chaptersColl addObject:cVO6];
    
    ChapterVO *cVO7 = [ChapterVO new];
    cVO7.chapterURL =@"3b-manhood-painting";
    [chaptersColl addObject:cVO7];
    
    ChapterVO *cVO8 = [ChapterVO new];
    cVO8.chapterURL =@"4a-oldage-text";
    [chaptersColl addObject:cVO8];
    
    ChapterVO *cVO9 = [ChapterVO new];
    cVO9.chapterURL =@"4b-oldage-painting";
    [chaptersColl addObject:cVO9];
    
    ChapterVO *cV1O = [ChapterVO new];
    cV1O.chapterURL =@"5-significance";
    [chaptersColl addObject:cV1O];
    
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
