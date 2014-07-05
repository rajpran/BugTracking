//
//  RemedyDetailsViewController.m
//  BugTracking
//
//  Created by Arun Shanmugam on 7/4/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "RemedyDetailsViewController.h"
#import "ESMImagePickerViewController.h"
#import "ESMAlertView.h"
#import "PickerViewController.h"
#import "ACEDropDown.h"

#import "AZUtils.h"
#import "Base64.h"

#define kKeyboardHeight @"352"


@interface RemedyDetailsViewController ()<ESMImagePickerViewControllerDelegate,ACEDropDownDelegate, UITextViewDelegate>{
    UIButton *clickedButton;
    NSInteger lastselectedtag;
    ACEDropDown * aCEDropDown;
    NSMutableArray *lovValues;
    
    CGFloat animatedDistance;
}
@property(strong, nonatomic) ESMImagePickerViewController *imagePickerViewController;
@property(strong, nonatomic) NSMutableArray *eventMaterialArray;
-(void) selectedSingleOption:(NSString *)selectedDict;
@property(strong, nonatomic) IBOutlet UIView *leftView;
@property(strong, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *productType;
@property (weak, nonatomic) IBOutlet UIButton *productButton;
@property (weak, nonatomic) IBOutlet UIButton *incidentType;
@property (weak, nonatomic) IBOutlet UIButton *priorityButton;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *incidentIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
- (IBAction)submitRemedy:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView *stepsTextView;
@property (weak, nonatomic) IBOutlet UITextView *statusReasonTextView;
@property (weak, nonatomic) IBOutlet UITextView *resolutionTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;





@end

@implementation RemedyDetailsViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 352;

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
    lastselectedtag=-1;
    _eventMaterialArray = [[NSMutableArray alloc] init];
    //[_addEventMaterialsbutton setBackgroundImage:[UIImage imageNamed:@"Add_material.png"] forState:UIControlStateNormal];
    //[_addEventMaterialsbutton setBackgroundImage:[UIImage imageNamed:@"Add_material_Active.png"] forState:UIControlStateHighlighted];
    _materialsScrollView.layer.borderColor=[UIColor lightGrayColor].CGColor;
	_materialsScrollView.layer.borderWidth = 1.0f;
    [self setLovs];
	// Do any additional setup after loading the view.
    
    self.summaryTextView.delegate = self;
    self.descriptionTextView.delegate = self;
    self.stepsTextView.delegate = self;
    self.statusReasonTextView.delegate = self;
    self.resolutionTextView.delegate = self;
    
    self.summaryTextView.backgroundColor = [UIColor colorWithRed:241/255 green:241/255 blue:241/255 alpha:0.1];
    self.descriptionTextView.backgroundColor = [UIColor colorWithRed:241/255 green:241/255 blue:241/255 alpha:0.1];
    self.stepsTextView.backgroundColor = [UIColor colorWithRed:241/255 green:241/255 blue:241/255 alpha:0.1];
    self.statusReasonTextView.backgroundColor = [UIColor colorWithRed:241/255 green:241/255 blue:241/255 alpha:0.1];
    self.resolutionTextView.backgroundColor = [UIColor colorWithRed:241/255 green:241/255 blue:241/255 alpha:0.1];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_centerbg.png"]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self resetRemedyDetails];
    if (_isNewRemedy) {
        int randomNumber = arc4random_uniform(900000) + 100000;
        _incidentIdLabel.text = [NSString stringWithFormat:@"INC%d",randomNumber];
        _userIdLabel.text =[AZUtils checkForNull:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"]];
        _submitBtn.tag = 0;
        [_submitBtn setTitle:@"Submit" forState:UIControlStateNormal];
        [self enableAllFields];
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserType"] isEqualToString:@"FieldUser"]){
            [self enableFieldsTechnicalUser];
            [self disableFieldsFiledUser];
        }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserType"] isEqualToString:@"TechicalUser"]){
            [self enableFieldsFiledUser];
            [self disableFieldsTechnicalUser];
        }
        

    }else{
        [self setRemedyValues];
        [self disableAllFields];
        _submitBtn.tag = 1;
        [_submitBtn setTitle:@"Edit" forState:UIControlStateNormal];
    }
}

-(void)resetRemedyDetails{
    _incidentIdLabel.text = @"";
    _userIdLabel.text = @"";
    _contactTextField.text = @"";
    _productType.titleLabel.text = @"";
    _productButton.titleLabel.text = @"";
    _summaryTextView.text = @"";
    _descriptionTextView.text = @"";
    _priorityButton.titleLabel.text = @"";
    _statusButton.titleLabel.text = @"";
    _statusReasonTextView.text = @"";
    _resolutionTextView.text = @"";
    _incidentType.titleLabel.text = @"";
    _stepsTextView.text = @"";
    
//    [_statusButton setTitle:@"-Select-" forState:UIControlStateNormal];
//    [_incidentType setTitle:@"-Select-" forState:UIControlStateNormal];
//    [_productType setTitle:@"-Select-" forState:UIControlStateNormal];
//    [_productButton setTitle:@"-Select-" forState:UIControlStateNormal];
//    [_priorityButton setTitle:@"-Select-" forState:UIControlStateNormal];
}
-(void)setRemedyValues{
    NSDictionary *remedyDetails = [AZUtils getPlistData:@"Data" key:_incidentID];
    _incidentIdLabel.text = [remedyDetails valueForKey:@"IncidentID"];
    _userIdLabel.text = [remedyDetails valueForKey:@"UserID"];
    _contactTextField.text = [remedyDetails valueForKey:@"Contact"];
    _summaryTextView.text = [remedyDetails valueForKey:@"Summary"];
    _statusReasonTextView.text = [remedyDetails valueForKey:@"StatusReason"];
    _resolutionTextView.text = [remedyDetails valueForKey:@"Resolution"];
    _stepsTextView.text = [remedyDetails valueForKey:@"StepsToReproduce"];
    _descriptionTextView.text = [remedyDetails valueForKey:@"description"];




    [_statusButton setTitle:[remedyDetails valueForKey:@"Status"] forState:UIControlStateNormal];
    [_incidentType setTitle:[remedyDetails valueForKey:@"IncidentType"] forState:UIControlStateNormal];
    [_productType setTitle:[remedyDetails valueForKey:@"ProductType"] forState:UIControlStateNormal];
    [_productButton setTitle:[remedyDetails valueForKey:@"Product"] forState:UIControlStateNormal];
    [_priorityButton setTitle:[remedyDetails valueForKey:@"Priority"] forState:UIControlStateNormal];
    [_eventMaterialArray removeAllObjects];
    if ([remedyDetails objectForKey:@"image"]) {
        for (NSString *base64String in [remedyDetails objectForKey:@"image"]) {
            NSData *imgData = [Base64 decode:base64String];
            UIImage *materialImage = [UIImage imageWithData:imgData];
            NSMutableDictionary *imageDic = [[NSMutableDictionary alloc] init];
            [imageDic setObject:materialImage forKey:@"image"];
            [imageDic setObject:@"" forKey:@"Id"];
            [_eventMaterialArray addObject:imageDic];
        }
    }
    
        [self reloadEventMaterial];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setLovs{
    lovValues = [[NSMutableArray alloc] init];
    [lovValues addObject:[[NSArray alloc]initWithObjects:@"Web Application",@"Mobile Application",nil]];
    NSMutableDictionary *temp1 = [[NSMutableDictionary alloc] init];
    
    [temp1 setValue:[[NSArray alloc]initWithObjects:@"EFCF",@"KIOSK",@"Service Request",@"iCall",@"iHub",nil]  forKey:@"Mobile Application"];
    [temp1 setValue:[[NSArray alloc]initWithObjects:@"EFCF Web",@"KIOSK Web",@"Service Request Web",nil]  forKey:@"Web Application"];

    [lovValues addObject:temp1];
    [lovValues addObject:[[NSArray alloc]initWithObjects:@"Query",@"Issue", nil]];
    [lovValues addObject:[[NSArray alloc]initWithObjects:@"Critical",@"High",@"Medium",@"Low", nil]];
    [lovValues addObject:[[NSArray alloc]initWithObjects:@"New",@"In progress",@"Assigned",@"Resolved", nil]];
}
-(IBAction)fromTheLibraryActions:(id)sender
{
    
//    NSMutableDictionary *dic = [[EventManager sharedInstance] getObject:KEventMaterialIdDic];
//    if(dic != nil && [dic count] > 0){
//        NSString *materilaID = [Utility getMaterialId:dic];
//        if(materilaID != nil){
//            selectedMaterialType = AzLocalizedString(@"AEmeetingDetailViewController1stPageButton", nil);
//            [[EventManager sharedInstance] setObject:materilaID forKey:KEventMaterialId];
//        }else{
//            [[EventManager sharedInstance] setObject:@"" forKey:KEventMaterialId];
//            return;
//        }
//        
//    }
    
    if(!_imagePickerViewController)
    {
        _imagePickerViewController=[[ESMImagePickerViewController alloc] init:sender];
        _imagePickerViewController.delegate = self;
    }
    [_imagePickerViewController pickFromGallery:sender];
    
}

#pragma ESMImagePickerViewControllerDelegate
-(void)setEventMaterialImage:(UIImage*)materialImage
{
    
    NSMutableDictionary *imageDic = [[NSMutableDictionary alloc]
                                     init];
//    if(state.isNetworkReachable){
//        ////////////////////////////////////////////////////////////
//        NSString* eventMaterialId = [[EventManager sharedInstance] getObject:KEventMaterialId];
//        NSMutableDictionary* eventOverView = [[EventManager sharedInstance] getObject:kEventMasterDetails];
//        
//        NSString *eventSub =[eventOverView objectForKey:@"Event_Subject__c"];
//        
//        NSData* imageData = [NSData dataWithData:UIImagePNGRepresentation(materialImage)];
//        NSString *base64Str = [Base64 encode:imageData];
//        NSString *attachmentName= [NSString stringWithFormat:@"%@.png",eventSub];
//        
//        NSDictionary *saveMaterialDic = [utility getQueryForInsertMaterial:eventMaterialId attachementName:attachmentName base64:base64Str];
//        if(_eventMaterialArray != nil && [_eventMaterialArray count] > 0){
//            NSString *attachmentId = [[_eventMaterialArray objectAtIndex:0] valueForKey:@"Id"];
//            if(attachmentId != nil && [attachmentId length] > 0 ){
//                NSMutableArray *deleteArray = [[NSMutableArray alloc] initWithArray:_eventMaterialArray];
//                [[EventManager sharedInstance] setObject:deleteArray forKey:kDeleteMateriaDetails];
//            }
//            [_eventMaterialArray removeAllObjects];
//        }
//        [imageDic setObject:materialImage forKey:@"image"];
//        [imageDic setObject:@"" forKey:@"Id"];
//        [imageDic setObject:AzLocalizedString(@"AEmeetingDetailViewController1stPageButton", nil) forKey:@"type"];
//        //[self deleteMaterialOnSaveSucess:selectedMaterialType];
//        [_eventMaterialArray addObject:imageDic];
//        
//        [[EventManager sharedInstance] setObject:_eventMaterialArray forKey:kEventMateriaDetails];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self reloadEventMaterial];
//        });
//    }else{
//        [imageDic setObject:materialImage forKey:@"image"];
//        [imageDic setObject:@"" forKey:@"Id"];
//        [imageDic setObject:AzLocalizedString(@"AEmeetingDetailViewController1stPageButton", nil) forKey:@"type"];
//        [self deleteMaterialOnSaveSucess:AzLocalizedString(@"AEmeetingDetailViewController1stPageButton", nil)];
//        if(_eventMaterialArray == nil)
//        {
//            _eventMaterialArray=[[NSMutableArray alloc]init];
//        }
//        [_eventMaterialArray addObject:imageDic];
//        [[EventManager sharedInstance] setObject:_eventMaterialArray forKey:kEventMateriaDetails];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self reloadEventMaterial];
//            [SVProgressHUD dismiss];
//        });
//    }
    
    [imageDic setObject:materialImage forKey:@"image"];
    [imageDic setObject:@"" forKey:@"Id"];
    //[imageDic setObject:AzLocalizedString(@"AEmeetingDetailViewController1stPageButton", nil) forKey:@"type"];
    //[self deleteMaterialOnSaveSucess:selectedMaterialType];
    [_eventMaterialArray addObject:imageDic];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadEventMaterial];
    });
}
- (void)reloadEventMaterial
{
    NSInteger mx = 10;
    NSInteger my = 0;
    
    for (UIView *subview in _materialsScrollView.subviews) {
        if([subview isKindOfClass:[UIImageView class]])
            [subview removeFromSuperview];
        
        if([subview isKindOfClass:[UIButton class]])
            [subview removeFromSuperview];
    }
    
    NSInteger count = [_eventMaterialArray count];
    for (NSInteger idx=0; idx < count; idx++) {
        UIImageView *materialImageView = [[UIImageView alloc] initWithImage:[[_eventMaterialArray objectAtIndex:idx] objectForKey:@"image"]];
        materialImageView.frame = CGRectMake(mx, my + 10, 60, _materialsScrollView.frame.size.height - 15);
        materialImageView.contentMode = UIViewContentModeScaleToFill;
        [_materialsScrollView addSubview:materialImageView];
        
        UIButton *imageViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageViewButton.frame = CGRectMake(materialImageView.frame.origin.x ,materialImageView.frame.origin.y, materialImageView.frame.size.width, materialImageView.frame.size.height);
        imageViewButton.tag = idx;
        [imageViewButton addTarget:self action:@selector(showEventMaterial:) forControlEvents:UIControlEventTouchUpInside];
        [_materialsScrollView addSubview:imageViewButton];
        
        //if(_blnEditing)
        //{
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(materialImageView.frame.origin.x + materialImageView.frame.size.width - 11, my, 25, 25);
            button.contentMode = UIViewContentModeScaleAspectFit;
            [button setImage:[UIImage imageNamed:@"img-del.png"] forState:UIControlStateNormal];
            button.tag = idx;
            [button addTarget:self action:@selector(deleteEventMaterial:) forControlEvents:UIControlEventTouchUpInside];
            [_materialsScrollView addSubview:button];
        //}
        mx += 80;
    }
    [_materialsScrollView setContentSize:CGSizeMake(count * 80, _materialsScrollView.frame.size.height)];
}
-(void)showEventMaterial:(id)sender{
    UIButton *button = (UIButton *)sender;
    _alert = [[ESMAlertView alloc] init];
    [_materialCloseButton setImage:[UIImage imageNamed:@"img-del.png"] forState:UIControlStateNormal];
    if(_eventMaterialArray != nil && [_eventMaterialArray count] > 0){
        _viewToShowMaterial.hidden = NO;
        _materialImageView.image = [[_eventMaterialArray objectAtIndex:button.tag] objectForKey:@"image"];
        [_alert setContainerView:_viewToShowMaterial];
        [_alert setUseMotionEffects:true];
        [_alert show];
    }
    
}
- (IBAction)deleteMaterial:(id)sender {
    [_alert close];
}
- (void)deleteEventMaterial:(id)sender
{
    if(_eventMaterialArray != nil && [_eventMaterialArray count] > 0){
        NSString *attachmentId = [[_eventMaterialArray objectAtIndex:0] valueForKey:@"Id"];
        if(attachmentId != nil && [attachmentId length] > 0 ){
            //NSMutableArray *deleteArray = [[NSMutableArray alloc] initWithArray:_eventMaterialArray];
            //[[EventManager sharedInstance] setObject:deleteArray forKey:kDeleteMateriaDetails];
        }
        UIButton *btn = (UIButton*)sender;
        [_eventMaterialArray removeObjectAtIndex:btn.tag];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadEventMaterial];
    });
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
        if([sender tag] == 1){
            categoryList=[[lovValues objectAtIndex:[sender tag]] valueForKey:_productType.titleLabel.text];
        }else{
            categoryList=[lovValues objectAtIndex:[sender tag]];
        }
        
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:categoryList forKey:@"dataSource"];
        [dict setObject:btnClicked forKey:@"button"];
        aCEDropDown=[[ACEDropDown alloc]initWithDropDwon:dict ];
        aCEDropDown.ddDelegate=self;

        [_leftView addSubview:aCEDropDown];

        lastselectedtag = [sender tag];
        
        
    }

}
-(void) selectedSingleOption:(NSDictionary *)selectedDict
{
    lastselectedtag = -1;

    
}


- (void)saveDataInPlist
{
    //Capture all the data entered in screen and save it in plist file
    
    NSString *incidentValue = @"";
    if ([_incidentIdLabel.text length] > 0) {
        incidentValue = _incidentIdLabel.text;
    }
    
    NSString *userIDValue = @"";
    if ([_userIdLabel.text length] > 0) {
        userIDValue = _userIdLabel.text;
    }
    
    NSString *contactValue = @"";
    if ([self.contactTextField.text length] > 0) {
        contactValue = self.contactTextField.text;
    }
    
    NSString *productTypeValue = @"";
    if ([_productType.titleLabel.text length] > 0) {
        productTypeValue = _productType.titleLabel.text;
    }
    
    NSString *productValue = @"";
    if ([_productButton.titleLabel.text length] > 0) {
        productValue = _productButton.titleLabel.text;
    }
    
    NSString *summaryValue = @"";
    if ([_summaryTextView.text length] > 0) {
        summaryValue = _summaryTextView.text;
    }
    
    NSString *stepsToReproduceValue = @"";
    if ([_summaryTextView.text length] > 0) {
        stepsToReproduceValue = _summaryTextView.text;
    }
    
    NSString *priorityValue = @"";
    if ([_priorityButton.titleLabel.text length] > 0) {
        priorityValue = _priorityButton.titleLabel.text;
    }
    
    NSString *statusValue = @"";
    if ([_statusButton.titleLabel.text length] > 0) {
        statusValue = _statusButton.titleLabel.text;
    }
    
    NSString *statusReasonValue = @"";
    if ([_statusReasonTextView.text length] > 0) {
        statusReasonValue = _statusReasonTextView.text;
    }
    
    NSString *resolutionValue = @"";
    if ([_resolutionTextView.text length] >0) {
        resolutionValue = _resolutionTextView.text;
    }
    NSString *incidentType = @"";
    if ([_incidentType.titleLabel.text length] >0) {
        incidentType = _incidentType.titleLabel.text;
    }
    NSString *desc = @"";
    if ([_descriptionTextView.text length] >0) {
        desc = _descriptionTextView.text;
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    df.timeStyle = NSDateFormatterMediumStyle;
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString* date = [df stringFromDate:[NSDate date]];
   
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (NSDictionary *imgDic in _eventMaterialArray) {
        NSData* imageData = [NSData dataWithData:UIImagePNGRepresentation([imgDic objectForKey:@"image"])];
        NSString *base64Str = [Base64 encode:imageData];
        [imageArray addObject:base64Str];
    }
    
    
    //Key name is the incident id
    NSString *key = _incidentIdLabel.text;
    NSDictionary *data = @{@"IncidentID": incidentValue,
                           @"UserID":userIDValue,
                           @"Contact":contactValue,
                           @"ProductType":productTypeValue,
                           @"Product":productValue,
                           @"Summary":summaryValue,
                           @"StepsToReproduce":stepsToReproduceValue,
                           @"Priority":priorityValue,
                           @"Status":statusValue,
                           @"StatusReason":statusReasonValue,
                           @"Resolution":resolutionValue,
                           @"IncidentType":incidentType,
                           @"description":desc,
                           @"CreatedDate":date,
                           @"image":imageArray};
    [AZUtils setPlistData:@"Data" key:key value:data];
    [[self navigationController] popToRootViewControllerAnimated:YES];

}

- (IBAction)submitRemedy:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        _submitBtn.tag = 2;
        [_submitBtn setTitle:@"Save" forState:UIControlStateNormal];
        [self enableAllFields];
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserType"] isEqualToString:@"FieldUser"]){
            [self enableFieldsTechnicalUser];
            [self disableFieldsFiledUser];
        }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserType"] isEqualToString:@"TechicalUser"]){
            [self enableFieldsFiledUser];
            [self disableFieldsTechnicalUser];
        }
    }else{
        [self saveDataInPlist];
    }
}

-(void) textViewDidBeginEditing:(UITextView *)textView {
    
    CGRect textFieldRect = [self.view.window convertRect:textView.bounds fromView:textView];
    
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0){
        
        heightFraction = 0.0;
        
    }else if(heightFraction > 1.0){
        
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
        
    }
    
    //TextViews added in right side are not moving up on keyboard presentation
    if (textView.tag == 11) {
        animatedDistance = 100;
    }
    
    if (textView.tag == 12) {
        animatedDistance = 200;
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)disableAllFields{
    _leftView.userInteractionEnabled = NO;
    [_productType setBackgroundImage:nil forState:UIControlStateNormal];
    //_productType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    [_productButton setBackgroundImage:nil forState:UIControlStateNormal];
    [_incidentType setBackgroundImage:nil forState:UIControlStateNormal];
    [_priorityButton setBackgroundImage:nil forState:UIControlStateNormal];
    [_statusButton setBackgroundImage:nil forState:UIControlStateNormal];

    
    _stepsTextView.userInteractionEnabled = NO;
    _descriptionTextView.userInteractionEnabled = NO;
    _statusReasonTextView.userInteractionEnabled = NO;
    _resolutionTextView.userInteractionEnabled = NO;
    _addEventMaterialsbutton.hidden = YES;
    for (UIView *subview in _materialsScrollView.subviews) {
        if([subview isKindOfClass:[UIButton class]])
            [subview removeFromSuperview];
    }
}
-(void)enableAllFields{
    _leftView.userInteractionEnabled = YES;
    [_productType setBackgroundImage:[UIImage imageNamed:@"choose_city.png"] forState:UIControlStateNormal];
    [_productButton setBackgroundImage:[UIImage imageNamed:@"choose_city.png"] forState:UIControlStateNormal];
    [_incidentType setBackgroundImage:[UIImage imageNamed:@"choose_city.png"] forState:UIControlStateNormal];
    [_priorityButton setBackgroundImage:[UIImage imageNamed:@"choose_city.png"] forState:UIControlStateNormal];
    [_statusButton setBackgroundImage:[UIImage imageNamed:@"choose_city.png"] forState:UIControlStateNormal];
    
    _stepsTextView.userInteractionEnabled = YES;
    _descriptionTextView.userInteractionEnabled = YES;
    _statusReasonTextView.userInteractionEnabled = YES;
    _resolutionTextView.userInteractionEnabled = YES;
    _addEventMaterialsbutton.hidden = NO;
    [self reloadEventMaterial];
}
-(void)disableFieldsFiledUser{
    _resolutionTextView.userInteractionEnabled = NO;
}
-(void)enableFieldsFiledUser{
    _resolutionTextView.userInteractionEnabled = YES;

}
-(void)disableFieldsTechnicalUser{
    _productType.userInteractionEnabled = NO;
    _productButton.userInteractionEnabled = NO;
    [_productType setBackgroundImage:nil forState:UIControlStateNormal];
    [_productButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    _summaryTextView.userInteractionEnabled = NO;
    _descriptionTextView.userInteractionEnabled = NO;
    _stepsTextView.userInteractionEnabled = NO;
    _addEventMaterialsbutton.hidden = YES;
    for (UIView *subview in _materialsScrollView.subviews) {
        if([subview isKindOfClass:[UIButton class]])
            [subview removeFromSuperview];
    }
    _contactTextField.userInteractionEnabled = NO;
}
-(void)enableFieldsTechnicalUser{
    _productType.userInteractionEnabled = YES;
    _productButton.userInteractionEnabled = YES;
    [_productType setBackgroundImage:[UIImage imageNamed:@"choose_city.png"] forState:UIControlStateNormal];
    [_productButton setBackgroundImage:[UIImage imageNamed:@"choose_city.png"] forState:UIControlStateNormal];
    
    _summaryTextView.userInteractionEnabled = YES;
    _descriptionTextView.userInteractionEnabled = YES;
    _stepsTextView.userInteractionEnabled = YES;
    _addEventMaterialsbutton.hidden = NO;
    [self reloadEventMaterial];
    _contactTextField.userInteractionEnabled = YES;
}
@end
