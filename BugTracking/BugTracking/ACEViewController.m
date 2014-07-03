//
//  ACEViewController.m
//  BugTracking
//
//  Created by Rajendra on 03/07/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "ACEViewController.h"

@interface ACEViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, copy) NSString *errorMessage;

- (IBAction)doLogin:(id)sender;

@end

@implementation ACEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLogin:(id)sender
{
    //Textfield validation
    BOOL correctInput = [self validateUserInput:[[self userNameTextField] text] password:[[self passwordTextField] text]];
    
//    if (correctInput) {
//        <#statements#>
//    }
}


/*Validate user input*/
- (BOOL)validateUserInput:(NSString *)email password:(NSString *)password
{
    BOOL validInput = YES;
    
    //Check if both fields are empty
    if ([email length] == 0 && [password length] == 0)
    {
        self.errorMessage = @"Please enter Email and Password";
        return validInput = NO;
    }else if ([email length] == 0 || [password length] == 0){
        //Check any one field is empty
        if ([email length] == 0) {
            self.errorMessage = @"Please enter Email Address";
            return validInput = NO;
        }else{
            self.errorMessage = @"Please enter Password";
            return validInput = NO;
        }
    }
    return validInput;
}

@end
