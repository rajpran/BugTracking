//
//  HomeViewController.m
//  BugTracking
//
//  Created by Arun Shanmugam on 7/3/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "HomeViewController.h"
#import "RemedyCell.h"
#import "PickerViewController.h"

@interface HomeViewController ()<UIPopoverControllerDelegate,SearchDelegate>
@property (weak, nonatomic) IBOutlet UILabel *RemedyId;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) PickerViewController *popoverContent;
- (IBAction)showSearchPicker:(id)sender;
@property (strong, nonatomic) UIDatePicker *datePicker;
- (IBAction)logOut:(id)sender;
@property (strong, nonatomic) NSDictionary *remediesDict;
@property (strong, nonatomic) NSArray *remedyKeysArray;


@end

@implementation HomeViewController

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
	// Do any additional setup after loading the view.
}
-(void)setremedyData{
    _remediesDict = [[NSDictionary alloc]init];
    _remedyKeysArray = [[NSArray alloc]init];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _remedyKeysArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemedyCell *cell = (RemedyCell *)[tableView dequeueReusableCellWithIdentifier:@"RemedyCell"];    
    return cell;
}

- (IBAction)showSearchPicker:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _popoverContent = [storyBoard instantiateViewControllerWithIdentifier:@"PickerViewController"];
    _popoverContent.delegate = self;
    _pickerPopover =[[UIPopoverController alloc] initWithContentViewController:_popoverContent];
    [_pickerPopover setPopoverContentSize:CGSizeMake(350, 400)];
    [_pickerPopover presentPopoverFromRect:button.frame inView:_titleView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    _pickerPopover.delegate = self;
}
- (IBAction)datePicker:(id)sender
{

}
-(void)searchRemedy:(NSDictionary *)searchData{

}
- (IBAction)logOut:(id)sender {
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}
@end
