//
//  HomeViewController.h
//  BugTracking
//
//  Created by Arun Shanmugam on 7/3/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
@property(strong, nonatomic) UIPopoverController *pickerPopover;
@property (strong, nonatomic) IBOutlet UIView *popoverView;

@end
