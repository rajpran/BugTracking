//
//  ACEDropDown.h
//  BaxterACE
//
//  Created by Meera Mohanan on 08/05/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ACEDropDownDelegate <NSObject>
@optional
//-(void) selectedSingleOption:(NSString *)string WithId:(NSString *)Idstring;

-(void) selectedSingleOption:(NSDictionary *)selectedDict;

@end

@interface ACEDropDown : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataSourceArray;// This is data source array
    UIButton *selectedButton;
    CGFloat tableViewRowHeight;
    NSUInteger lastSelectedIndex;
    NSArray *arr_datasourceIds;
    
    

}
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong) NSArray *arr_datasourceIds;;
@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, weak) id <ACEDropDownDelegate> ddDelegate;

- (id)initWithDropDwon:(NSDictionary *)data;
-(void)removePopDropDown:(UIView*)view;

@end
