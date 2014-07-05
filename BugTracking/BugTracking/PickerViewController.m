//
//  PickerViewController.m
//  BugTracking
//
//  Created by Arun Shanmugam on 7/4/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "PickerViewController.h"
#import "ACEDropDown.h"
#import "AZUtils.h"

@interface PickerViewController ()<UIPopoverControllerDelegate,ACEDropDownDelegate>{
    UIButton *clickedButton;
    NSInteger lastselectedtag;
    ACEDropDown * aCEDropDown;
    NSMutableArray *lovValues;
}
- (IBAction)searchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *pickerTableView;
- (IBAction)showDatePicker:(id)sender;
- (IBAction)resetSearchData:(id)sender;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIButton *priorityBtn;
@property (weak, nonatomic) IBOutlet UIButton *productBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UITextField *requestIdTxt;

@property (strong, nonatomic) UIPopoverController *pickerPopover;
@end

@implementation PickerViewController

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
    lastselectedtag = -1;
    [self setLovs];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    df.timeStyle = NSDateFormatterMediumStyle;
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString* date = [df stringFromDate:[NSDate date]];
    NSLog(@"%@",date);
    //_dateButton.titleLabel.text = date;
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showDatePicker:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    NSDate *eventEndDate;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    [df setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 375, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone:)];
    doneBtn.tag = button.tag;
    [barItems addObject:doneBtn];
    [pickerToolbar setItems:barItems animated:YES];
    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    _datePicker.tag = button.tag;
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    NSDate *eventStartDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 344)];
    popoverView.backgroundColor = [UIColor whiteColor];
    
    _datePicker.frame = CGRectMake(0, 44, 250, 300);
    
    [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [popoverView addSubview:pickerToolbar];
    [popoverView addSubview:_datePicker];
    popoverContent.view = popoverView;
    //resize the popover view shown
    //in the current view to the view's size
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    popoverContent.preferredContentSize = CGSizeMake(250, 244);
#else
    popoverContent.contentSizeForViewInPopover = CGSizeMake(250, 244);
#endif
    
    //create a popover controller
    _pickerPopover = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    [_pickerPopover presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    _pickerPopover.delegate=self;
}

- (IBAction)resetSearchData:(id)sender {
}
-(IBAction)dateChange:(id)sender{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    df.timeStyle = NSDateFormatterMediumStyle;
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString* date = [df stringFromDate:_datePicker.date];
    NSLog(@"%@",date);
    _dateButton.titleLabel.text = date;

}

-(IBAction)pickerDone:(id)sender{

    if (_pickerPopover != nil) {
        [_pickerPopover dismissPopoverAnimated:YES];
        _pickerPopover=nil;
    }
}
-(IBAction)showPicker:(id)sender{
    if (lastselectedtag == [sender tag])
    {
        lastselectedtag = -1;
        [aCEDropDown removeFromSuperview];
        aCEDropDown = nil;
    }
    else{
        clickedButton=(UIButton *)sender;
        aCEDropDown=[[ACEDropDown alloc]init];
        UIButton *btnClicked=(UIButton *)sender;
        NSArray *categoryList = [[NSArray alloc] init];
        categoryList=[lovValues objectAtIndex:[sender tag]];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:categoryList forKey:@"dataSource"];
        [dict setObject:btnClicked forKey:@"button"];
        aCEDropDown=[[ACEDropDown alloc]initWithDropDwon:dict ];
        aCEDropDown.ddDelegate=self;
        [self.view addSubview:aCEDropDown];
        lastselectedtag = [sender tag];
    }
    
}
-(void)setLovs{
    lovValues = [[NSMutableArray alloc] init];
    [lovValues addObject:[[NSArray alloc]initWithObjects:@"New",@"In progress",@"Assigned",@"Resolved", nil]];
    [lovValues addObject:[[NSArray alloc]initWithObjects:@"Critical",@"High",@"Medium",@"Low", nil]];
    [lovValues addObject:[[NSArray alloc]initWithObjects:@"EFCF",@"KIOSK",@"Service Request",@"iCall",@"iHub", nil]];
}
-(void) selectedSingleOption:(NSDictionary *)selectedDict
{
    lastselectedtag = -1;
}
- (IBAction)searchAction:(id)sender
{
    NSMutableDictionary *searchDict = [[NSMutableDictionary alloc] init];
    
    [searchDict setValue:[AZUtils checkForNull:_statusBtn.titleLabel.text] forKey:@"Status"];
    [searchDict setValue:[AZUtils checkForNull:_priorityBtn.titleLabel.text] forKey:@"Priority"];
    [searchDict setValue:[AZUtils checkForNull:_productBtn.titleLabel.text] forKey:@"Product"];
    [searchDict setValue:[AZUtils checkForNull:_requestIdTxt.text] forKey:@"RequestId"];
    [searchDict setValue:[AZUtils checkForNull:_dateButton.titleLabel.text] forKey:@"CreatedOn"];
    
    
    [_delegate searchRemedy:searchDict];
}


@end
