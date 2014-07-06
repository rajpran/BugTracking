//
//  ACEViewController.m
//  BugTracking
//
//  Created by Rajendra on 03/07/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "ACEViewController.h"
#import "HomeViewController.h"

@interface ACEViewController ()<NSXMLParserDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, strong) NSMutableData *webData;
@property (nonatomic, assign) BOOL serviceSuccuess;

- (IBAction)doLogin:(id)sender;

@end

@implementation ACEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.serviceSuccuess = NO;
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 0)];
    [_userNameTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_userNameTextField setLeftView:spacerView];
    
    UIView *spacerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,10, 0)];

    [_passwordTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_passwordTextField setLeftView:spacerView1];
    

    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
	
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.userNameTextField.text = @"";
    self.passwordTextField.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLogin:(id)sender
{
    
    [SVProgressHUD showWithStatus:@"Loading.."];
    //Textfield validation
    BOOL correctInput = [self validateUserInput:[[self userNameTextField] text] password:[[self passwordTextField] text]];
    
    if (correctInput) {
        
        [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:@"UserName"];
        [[NSUserDefaults standardUserDefaults] setObject:@"TechicalUser" forKey:@"UserType"];

        
        if ([_userNameTextField.text isEqualToString:@"kdsd708"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"Robert" forKey:@"FirstName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"Trempe" forKey:@"LastName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"+1 302 886 1021" forKey:@"Contact"];
            [[NSUserDefaults standardUserDefaults] setObject:@"FieldUser" forKey:@"UserType"];
            
        }else if([_userNameTextField.text isEqualToString:@"knxz537"]){
            [[NSUserDefaults standardUserDefaults] setObject:@"Kamal" forKey:@"FirstName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"kannan" forKey:@"LastName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"+91 9884565895" forKey:@"Contact"];
        }

        

        NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:soap=\"http://na.az.com/soaplatform\" xmlns:urn=\"urn:astrazeneca:na:Employee:services:EmployeeDataInitiatior:2\">\n"
                               "<soapenv:Header>\n"
                               "<urn:HeaderParams>\n"
                               "<appid>kiosk</appid>\n"
                               "<CountryCode>US</CountryCode>\n"
                               "</urn:HeaderParams>\n"
                               "<wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\">\n"
                               "<wsse:UsernameToken>\n"
                               "<wsse:Username>kzmg940</wsse:Username>\n"
                               "<wsse:Password Type=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText\">d12srvepsh</wsse:Password>\n"
                               "</wsse:UsernameToken>\n"
                               "</wsse:Security>\n"
                               " </soapenv:Header>\n"
                                 "<soapenv:Body>\n"
                               "<urn:AuthenticateUser>\n"
                               "<urn:EmployeeId SystemCode=\"PRID\">%@</urn:EmployeeId>\n"
                               "<!--Optional:-->\n"
                               "<urn:domain>americas</urn:domain>\n"
                               "<!--Optional:-->\n"
                               "<urn:location>US</urn:location>\n"
                               "</urn:AuthenticateUser>\n"
                               "</soapenv:Body>\n"
                               "</soapenv:Envelope>"
                               ,self.userNameTextField.text];
        
        NSLog(@"XML request string:%@",soapMessage);
        
        NSData *envelope = [soapMessage dataUsingEncoding:NSUTF8StringEncoding];
        
        // construct request
        
        NSString *url = @"https://gateway.astrazeneca-us.com/dmnContact/EmployeeService";
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [request addValue:@"http://na.az.com/soaplatform" forHTTPHeaderField:@"SOAPAction"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:envelope];
        [request setValue:@"application/soap+xml; charset=utf-8"
       forHTTPHeaderField:@"Content-Type"];
        
        [request setValue:[NSString stringWithFormat:@"%d", [envelope length]]forHTTPHeaderField:@"Content-Length"];
        
        // fire away
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection)
            self.webData = [NSMutableData data];
        else
            NSLog(@"NSURLConnection initWithRequest: Failed to return a connection.");
        
    }else{
        [SVProgressHUD dismiss];
        //Clear password field
        self.passwordTextField.text = @"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:self.errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

}


/*Validate user input*/
- (BOOL)validateUserInput:(NSString *)iEmail password:(NSString *)iPassword
{
    BOOL validInput = YES;
    
    //Check if both fields are empty
    if ([iEmail length] == 0 && [iPassword length] == 0)
    {
        self.errorMessage = @"Please enter Email and Password";
        return validInput = NO;
    }else if ([iEmail length] == 0 || [iPassword length] == 0){
        //Check any one field is empty
        if ([iEmail length] == 0) {
            self.errorMessage = @"Please enter Email Address";
            return validInput = NO;
        }else{
            self.errorMessage = @"Please enter Password";
            return validInput = NO;
        }
    }
    return validInput;
}

#pragma mark - NSURLConnection delegate methods
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR with theConenction");
    [SVProgressHUD dismiss];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"DONE. Received Bytes: %d", [self.webData length]);
    NSString *theXML = [[NSString alloc] initWithBytes:
                        [self.webData mutableBytes] length:[self.webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"XML Reseponse:%@",theXML);
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:self.webData];
    
    // Don't forget to set the delegate!
    xmlParser.delegate = self;
    
    // Run the parser
    BOOL parsingResult = [xmlParser parse];
}

#pragma mark - XML parser delegate methods

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    NSLog(@"Tag name:%@",elementName);
    
    
    NSString  *currentDescription = [NSString alloc];
    element=elementName;
    att=[attributeDict objectForKey:@"SystemCode"];
    
    if ([elementName isEqualToString:@"StatusCode"]) {
        self.serviceSuccuess = YES;
    }
    
    if ([elementName isEqualToString:@"JobCode"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"FieldUser" forKey:@"UserType"];
    }
    
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if (self.serviceSuccuess)
    {
        if([element isEqualToString:@"EmployeeID"] && [att isEqualToString:@"EMAIL"])
        {
            email = string;
            NSLog(@"email %@",email);
            [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"Email"];
        }
        
        if([element isEqualToString:@"EmployeeID"] && [att isEqualToString:@"NT USERNAME"])
        {
            userName = string;
            NSLog(@"User Name %@",userName);
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"UserName"];
        }
        
        if ([element isEqualToString:@"FirstName"]) {
            firstName = string;
            NSLog(@"First name is:%@",firstName);
            [[NSUserDefaults standardUserDefaults] setObject:firstName forKey:@"FirstName"];
        }
        
        if ([element isEqualToString:@"LastName"]) {
            lastName = string;
            NSLog(@"Last name is:%@",lastName);
            [[NSUserDefaults standardUserDefaults] setObject:lastName forKey:@"LastName"];
        }
        
        if ([element isEqualToString:@"Value"]) {
            
            NSLog(@"Contact is:%@",string);
            [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"Contact"];
        }
        
        
    }else{
        
        [SVProgressHUD dismiss];
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeViewController *hVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        UINavigationController *nVC = [[UINavigationController alloc] initWithRootViewController:hVC];
        [self presentViewController:nVC animated:YES completion:nil];

    }
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"DidEndElement:%@",elementName);
    
    //After parsing the last tag show the home page
    if ([elementName isEqualToString:@"soapenv:Envelope"]) {
        [SVProgressHUD dismiss];
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeViewController *hVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        UINavigationController *nVC = [[UINavigationController alloc] initWithRootViewController:hVC];
        [self presentViewController:nVC animated:YES completion:nil];
    }
}


@end
