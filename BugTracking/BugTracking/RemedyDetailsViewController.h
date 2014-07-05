//
//  RemedyDetailsViewController.h
//  BugTracking
//
//  Created by Arun Shanmugam on 7/4/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESMAlertView.h"

@interface RemedyDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *addEventMaterialsbutton;
@property (weak, nonatomic) IBOutlet UIScrollView *materialsScrollView;
@property (strong, nonatomic) ESMAlertView *alert;
@property (strong, nonatomic) IBOutlet UIView *viewToShowMaterial;
@property (strong, nonatomic) IBOutlet UIImageView *materialImageView;
@property (strong, nonatomic) IBOutlet UIButton *materialCloseButton;
@property(strong, nonatomic) UIPopoverController *pickerPopover;
@property(assign,nonatomic) BOOL isNewRemedy;
- (void)deleteEventMaterial:(id)sender;
@end
