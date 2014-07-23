//
//  StickyNoteViewController.m
//  EpubRnD
//
//  Created by UdaySravan K on 17/07/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "StickyNoteViewController.h"

@interface StickyNoteViewController ()

@end

@implementation StickyNoteViewController

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
    self.labelSelectedText.text = self.highlightVO.selectedText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeNoteEditor:(id)sender
{
    [self.myDelegate didCloseStickyNoteWindow];
    [self.view removeFromSuperview];
    NSLog(@"no problem here");
}

@end
