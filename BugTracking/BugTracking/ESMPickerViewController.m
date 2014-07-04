//
//  EventPickerViewController.m
//  ESM
//
//  Created by Administrator on 1/8/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "ESMPickerViewController.h"

@implementation PickerViewParams
{
}
@end

@interface ESMPickerViewController()
@property(nonatomic,assign) NSInteger tag;
@end

@implementation ESMPickerViewController

#pragma mark - Init
-(id)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style] != nil) {
        self.tag = 0;
        _items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)setItems:(NSArray *)items tag:(NSInteger)tag
{
    //Initialize the array
    _items = [items copy];
    self.tag = tag;
    //Make row selections persist.
    self.clearsSelectionOnViewWillAppear = NO;
    
    //Calculate how tall the view should be by multiplying the individual row height
    //by the total number of rows.
    NSInteger rowsCount = [_items count];
    NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSInteger totalRowsHeight = rowsCount * singleRowHeight;
    
    //Calculate how wide the view should be by finding how wide each string is expected to be
    CGFloat largestLabelWidth = 0;
    NSInteger count = [_items count];
    for (NSInteger idx=0; idx<count; idx++) {
        NSString *itemName;
        if(self.tag == TAG_EVENT_TYPE || self.tag == TAG_EVENT_SUB_TYPE || self.tag == TAG_TARGET_CITY)
            itemName = [[_items objectAtIndex:idx] objectForKey:@"Name"];
        else
            itemName = [_items objectAtIndex:idx];
      
        //Checks size of text using the default font for UITableViewCell's textLabel.
        
        CGSize labelSize;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]};
        labelSize = [itemName sizeWithAttributes:attributes];
#else
        labelSize = [itemName sizeWithFont:[UIFont systemFontOfSize:14.0f]];
#endif
        
        if (labelSize.width > largestLabelWidth) {
            largestLabelWidth = labelSize.width;
        }
    }
    
    //Add a little padding to the width
    CGFloat popoverWidth = largestLabelWidth + 100;
    
    //Set the property to tell the popover container how big this view will be.
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    self.preferredContentSize = CGSizeMake(popoverWidth, totalRowsHeight);
#else
    self.contentSizeForViewInPopover = CGSizeMake(popoverWidth, totalRowsHeight);
#endif
}

-(void)setSize:(NSInteger)width height:(NSInteger)height
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    self.preferredContentSize = CGSizeMake(width, height);
#else
    self.contentSizeForViewInPopover = CGSizeMake(width, height);
#endif
    
    [self.tableView reloadData];
}

-(void)setSelectedItem:(NSString*)item
{
    
    if(self.tag == TAG_TARGET_CITY)
        return;
    if([item isEqualToStr:AzLocalizedString(@"AEeventDetailViewControllerEventType", nil)] || [item isEqualToStr:AzLocalizedString(@"AEeventDetailViewControllerEventSubType", nil)])
        return;
    
    NSInteger rowIdx = -1;
    NSInteger count = [_items count];
    for (NSInteger idx=0; idx<count; idx++) {
        NSString *itemName;
        if(self.tag == TAG_EVENT_TYPE || self.tag == TAG_EVENT_SUB_TYPE)
            itemName = [[_items objectAtIndex:idx] objectForKey:@"Name"];
        else
            itemName = [_items objectAtIndex:idx];

        if([item isEqualToStr:itemName])
        {
            rowIdx = idx;
            break;
        }
    }
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:rowIdx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
  /*  if(self.tag == TAG_EVENT_TYPE)
        return 1;
    */
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if(self.tag == TAG_EVENT_TYPE || self.tag == TAG_EVENT_SUB_TYPE || self.tag == TAG_TARGET_CITY)
        cell.textLabel.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"Name"];
    else
        cell.textLabel.text = [_items objectAtIndex:indexPath.row];

    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *itemName;
    if(self.tag == TAG_EVENT_TYPE || self.tag == TAG_EVENT_SUB_TYPE || self.tag == TAG_TARGET_CITY)
        itemName = [[_items objectAtIndex:indexPath.row] objectForKey:@"Name"];
    else
        itemName = [_items objectAtIndex:indexPath.row];

    //Notify the delegate if it exists.
    if (_delegate != nil) {
        NSString *itemId = [NSString stringWithFormat:@"%d",indexPath.row];
        if (self.tag == TAG_EVENT_TYPE) {
            if([_items count] > 0)
            {
                NSMutableArray *eventTypearray = [NSMutableArray arrayWithArray:_items];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name == %@", itemName];
                [eventTypearray filterUsingPredicate:predicate];
            
                itemId = [[eventTypearray objectAtIndex:0] objectForKey:@"Id"];
            }
        }
        
        if (self.tag == TAG_EVENT_SUB_TYPE || self.tag == TAG_TARGET_CITY) {
            if([_items count] > 0)
            {
                NSMutableArray *eventSubTypearray = [NSMutableArray arrayWithArray:_items];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name == %@", itemName];
                [eventSubTypearray filterUsingPredicate:predicate];
                
                itemId = [[eventSubTypearray objectAtIndex:0] objectForKey:@"Id"];
            }
        }
        
        [_delegate selectedItem:itemId itemName:itemName tag:self.tag];
    }
}

@end
