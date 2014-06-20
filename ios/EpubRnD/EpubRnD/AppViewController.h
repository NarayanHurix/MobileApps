//
//  AppViewController.h
//  EpubWithPageController
//
//  Created by UdaySravan K on 21/04/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface AppViewController : UIViewController

@property (strong,nonatomic) MainViewController *myPVC ;

- (IBAction)openBook:(id)sender;

@end
