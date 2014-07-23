//
//  HighlightPopupViewController.m
//  EpubRnD
//
//  Created by UdaySravan K on 01/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "HighlightPopupViewController.h"


@interface HighlightPopupViewController ()

@end

@implementation HighlightPopupViewController
@synthesize myWebView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickOnSave:(id)sender
{
    [myWebView saveHighlight];
}
- (IBAction)Close:(id)sender
{
    [myWebView closePopupAndClearHighlight];
}

- (IBAction)addStickyNote:(UIButton *)sender
{
    [myWebView addNoteAndClosePopup];
}

- (IBAction)copySelectedText:(id)sender
{
    [myWebView stringByEvaluatingJavaScriptFromString:@"copySelectedTextToPasteBoard()"];
}
@end
