//
//  RemedyCell.h
//  BugTracking
//
//  Created by Arun Shanmugam on 7/3/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemedyCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *remedyIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *incidentTypeLabel;
@end
