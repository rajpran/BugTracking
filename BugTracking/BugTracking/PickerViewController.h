//
//  PickerViewController.h
//  BugTracking
//
//  Created by Arun Shanmugam on 7/4/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchDelegate <NSObject>
-(void)searchRemedy:(NSDictionary *) searchData;
@end
@interface PickerViewController : UIViewController
@property NSString *selectedValue;
@property NSMutableArray *pickerValues;
@property (assign, nonatomic) id<SearchDelegate> delegate;
@end
