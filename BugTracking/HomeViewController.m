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
#import "AZUtils.h"
#import "RemedyDetailsViewController.h"

@interface HomeViewController ()<UIPopoverControllerDelegate,SearchDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *remedyTableView;
@property (weak, nonatomic) IBOutlet UILabel *RemedyId;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) PickerViewController *popoverContent;
- (IBAction)showSearchPicker:(id)sender;
@property (strong, nonatomic) UIDatePicker *datePicker;
- (IBAction)logOut:(id)sender;
@property (strong, nonatomic) NSDictionary *remediesDict;
@property (strong, nonatomic) NSArray *remedyKeysArray;
@property (weak, nonatomic) NSString *incidentId;


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
    
    _remediesDict = [AZUtils getCompletePlistData];
    
    _remedyKeysArray = [_remediesDict allKeys];
}
-(void)viewWillAppear:(BOOL)animated{
    [self setremedyData];
    [_remedyTableView reloadData];
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
    NSDictionary *remedyDict = [_remediesDict objectForKey:[_remedyKeysArray objectAtIndex:indexPath.row]];
    
    
    cell.summaryLabel.text = [remedyDict valueForKey:@"Summary"];
    cell.remedyIDLabel.text = [remedyDict valueForKey:@"IncidentID"];
    cell.statusLabel.text = [remedyDict valueForKey:@"Status"];
    cell.createdDateLabel.text = [remedyDict valueForKey:@"CreatedDate"];
    cell.productLabel.text = [remedyDict valueForKey:@"Product"];
    cell.priorityLabel.text = [remedyDict valueForKey:@"Priority"];
    cell.incidentTypeLabel.text = [remedyDict valueForKey:@"IncidentType"];

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RemedyDetailsViewController *remedyViewController = [storyBoard instantiateViewControllerWithIdentifier:@"RemedyDetailsViewController"];
    [[self navigationController] pushViewController:remedyViewController animated:YES];
    remedyViewController.incidentID = [_remedyKeysArray objectAtIndex:indexPath.row];
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
    
    NSLog(@"Search dict:%@",searchData);
    
    if (searchData && [[searchData allKeys] count] > 0) {
        
        NSMutableDictionary *filterDict = [[NSMutableDictionary alloc] init];
        //Check for the keys having value without empty string and capture it in another dictionary
        for (NSString *key in [searchData allKeys]) {
            NSString *value = [searchData objectForKey:key];
            if (![value isEqualToString:@""]) {
                [filterDict setObject:value forKey:key];
            }
        }
        
        NSLog(@"Filtered Dict:%@",filterDict);
        
        
        
        NSArray *data = [_remediesDict allValues];
        
        
        
    }

}
- (IBAction)logOut:(id)sender {
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //UINavigationController *navigationController = segue.destinationViewController;
    RemedyDetailsViewController *controller = (RemedyDetailsViewController *)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"CreateNew"]) {
        controller.isNewRemedy = YES;
    }
//    } else if ([segue.identifier isEqualToString:@"Details"]) {
//        controller.isNewRemedy = NO;
//        controller.incidentID  = _incidentId;
//
//    }
}
@end
