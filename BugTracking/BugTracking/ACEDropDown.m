//
//  ACEDropDown.m
//  BaxterACE
//
//  Created by Meera Mohanan on 08/05/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "ACEDropDown.h"

@implementation ACEDropDown{
    NSArray *sourceArray;
}
@synthesize dataSourceArray,selectedButton,arr_datasourceIds;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithDropDwon:(NSDictionary *)data
{
    self= [super init];
    if (self) {
        
            //Check parameter dictionary is not nil
        if (data) {
                //  sourceArray=[[NSArray alloc]initWithObjects:[data objectForKey:@"dataSource"], nil];
            self.dataSourceArray=[data objectForKey:@"dataSource"];
                // self.arr_datasourceIds=[data valueForKey:@"kRepIds"];
            self.selectedButton=[data valueForKey:@"button"];
        }
        tableViewRowHeight=45.0;
        CGFloat height =  0.0;
        height = [self.dataSourceArray count] * tableViewRowHeight;
            //If no of rows are more, set the the table view height to 222.0
        if (height > 222.0) {
            height = 222.0;
        }
        CGRect frame = self.selectedButton.frame;
        
        [self setFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame), frame.size.width, height)];
        
			//Set delegates
        self.delegate = self;
        self.dataSource = self;

              }
    return self;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1]];
    
    
}
-(void)removePopDropDown:(UIView*)view
{
    NSArray *subViews = [view subviews];
    if ([subViews count] > 0) {
        for (id obj in subViews) {
            if ([obj isKindOfClass:[ACEDropDown class]]) {
                [obj removeFromSuperview];
                
                
                
            }
        }
    }
}
- (void)dismissDropDown:(UITableView *)tableView
{
    [self removeFromSuperview];
}
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tableViewRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //In iOS7 cell seperation line to start from 0, we have to set this property
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    
    //Display text on cell
    @try {
        cell.textLabel.text = [self.dataSourceArray objectAtIndex:indexPath.row];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@",exception.reason);
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//        //Get respective key based on use selection
//    NSDictionary *dict = [sourceArray objectAtIndex:0];
//    NSString *value = [dataSourceArray objectAtIndex:indexPath.row];
//    NSString *key=[[[sourceArray objectAtIndex:0] allKeys] objectAtIndex:indexPath.row];
   NSString *str = [self.dataSourceArray objectAtIndex:indexPath.row];
//    
    
    
        //   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        //In single selction mode capture the selected index, to show the checked image on next launcn
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [self.selectedButton setTitle:[self.dataSourceArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
            //Send the selected string to respective view by using delegate method
        if ([self.ddDelegate respondsToSelector:@selector(selectedSingleOption:)]) {
           
            
            [self.ddDelegate selectedSingleOption:str];
        }
        
            //Dismiss the pop after 2secs
        [self performSelector:@selector(dismissDropDown:) withObject:tableView afterDelay:0.1];
         lastSelectedIndex = indexPath.row;
        
        [self reloadData];
        
        
    
}

@end
