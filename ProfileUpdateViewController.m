//
//  ProfileUpdateViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//
#import "Passwordchange.h"
#import "ProfileUpdateViewController.h"
#import "lmsmoocAppDelegate.h"
#import "databaseurl.h"
#import "SBJSON.h"
#import "DashboardContentListTableViewController.h"
#import "AvatarImagesViewController.h"
#import "UIButton+Bootstrap.h"

#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface ProfileUpdateViewController ()
{
    DashboardContentListTableViewController *list;
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
}
@end

@implementation ProfileUpdateViewController
@synthesize fname;
@synthesize lname;
@synthesize username;
@synthesize email;
@synthesize password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    password.text=[delegate.Profiledetails objectForKey:@"password"];
     
    NSLog(@"value image %@",[delegate.Profiledetails valueForKey:@"avatarImage"]);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.saveprofile primaryStyle];
    // Do any additional setup after loading the view.
    if (self.navigationController.navigationBar.hidden == YES)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    list=[[DashboardContentListTableViewController alloc]init];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(menulistener:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menulistener:)
                                                 name:@"Showmenu"
                                               object:nil];
   
    
     du=[[databaseurl alloc]init];
    fname.delegate = self;
    lname.delegate=self;
    username.delegate=self;
    password.delegate = self;
   
    email.delegate=self;
    interestedval=@"null";
    genderval=@"null";
    UITapGestureRecognizer *get=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:get];
    
   delegate=AppDelegate;
    if(delegate.Profiledetails)
    {
        [self setvalues];
    }
//    delegate.avatharimage= @"http://208.109.248.89:8085/OnlineCourse/resources/images/users/g6.png";
//    delegate.av_image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:delegate.avatharimage]]];
//    [list reloadTableContent];
    
}

-(void)setvalues
{
  delegate=AppDelegate;
    fname.text=[delegate.Profiledetails objectForKey:@"firstname"];
   lname.text=[delegate.Profiledetails objectForKey:@"lastname"];
    username.text=[delegate.Profiledetails objectForKey:@"username"];
    email.text=[delegate.Profiledetails objectForKey:@"email"];
    password.text=[delegate.Profiledetails objectForKey:@"password"];
    interestedval=[delegate.Profiledetails objectForKey:@"interested_in"];
    genderval=[delegate.Profiledetails objectForKey:@"gender"];
    
    if ([genderval isEqualToString:@"female"]) {
        [_gender setSelectedSegmentIndex:1];
    }
    else if ([genderval isEqualToString:@"male"]){
        [_gender setSelectedSegmentIndex:0];
    }
    if ([interestedval isEqualToString:@"courses"]) {
        [_interestedin setSelectedSegmentIndex:1];
    }
    else if([interestedval isEqualToString:@"subject"]) {
        [_interestedin setSelectedSegmentIndex:0];
    }

    
}
-(void)dismissKeyboard
{
    [fname resignFirstResponder];
    [lname resignFirstResponder];
    [username resignFirstResponder];
    [email resignFirstResponder];

    [password resignFirstResponder];
    
}
- (void)menulistener:(id)sender {
    
    
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Showmenu" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signup:(id)sender {
    int c=1;
    [self dismissKeyboard];
    if (fname.text.length>0 &&
        lname.text.length>0 &&
        username.text.length>0 &&
        password.text.length>0 &&
        email.text.length>0 )
    {
        if ([du validateNameForSignupPage:fname.text])
        {
            if ([du validateNameForSignupPage:lname.text])
            {
                
                if ([du validateUserNameForSignupPage:username.text])
                {
                    if ([du validateEmailForSignupPage:email.text])
                    {
                        if ([du validatePasswordForSignupPage:password.text])
                        {
                          
                            [delegate.Profiledetails setValue:fname.text forKey:@"firstname"];
                            [delegate.Profiledetails setValue:lname.text forKey:@"lastname"];
                            [delegate.Profiledetails setValue:email.text forKey:@"email"];
                            [delegate.Profiledetails setValue:interestedval forKey:@"interested_in"];
                            [delegate.Profiledetails setValue:genderval forKey:@"gender"];
//                            [delegate.Profiledetails setValue:[menu objectForKey:@"avatarURL"] forKey:@"avatarURL"];
//                            [delegate.Profiledetails setValue:[menu objectForKey:@"avatarImage"] forKey:@"avatarImage"];
//                            [delegate.Profiledetails setValue:[menu objectForKey:@"logins"] forKey:@"logins"];
                            password.text=[delegate.Profiledetails objectForKey:@"password"];
                    
                            NSLog(@"dictionary values %@",delegate.Profiledetails);
                        }
                        else
                        {
                            c = 0;
                            // enter organization TextField
                            NSLog(@"ENTER VALID password");
                            
                        }
                    }
                    else
                    {
                        c = 0;
                        // enter organization TextField
                        NSLog(@"ENTER VALID email id");
                        
                    }
                }
                else
                {
                    c = 0;
                    // enter email TextField
                    NSLog(@"ENTER VALID username");
                    
                }
            }
            else
            {
                c=0;
                //enter lastname TextField
                NSLog(@"ENTER VALID LAST NAME");
                
            }
        }
        else
        {
            c=0;
            //enter firstname TextField
            NSLog(@"ENTER VALID FIRST NAME");
            
        }
    }
    else
    {
        c=0;
        //enter all required fields
        NSLog(@"ENTER ALL REQUIRED FIELDS");
        
        
    }
    if (c==1)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
        HUD.mode=MBProgressHUDModeIndeterminate;
        HUD.delegate = self;
        HUD.labelText = @"Please wait";
        [HUD show:YES];
        if ([[du submitvalues]isEqualToString:@"Success"])
        {
            [self signupdata];
        }
        else
        {
            //[HUD hide:YES];
            HUD.labelText = @"Check network connection";
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]] autorelease];
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD hide:YES afterDelay:1];
        }
        
    }
    
    
}
-(void)reset
{
    
    fname.text=@"";
    lname.text=@"";
    email.text=@"";
   
    
    
}


-(void)signupdata
{
    
    NSString *response=[self HttpPostEntityFirst1:@"firstname" ForValue1:fname.text  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
    
    NSError *error;
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *parsedvalue = [json objectWithString:response error:&error];
    
    //  NSLog(@"%@ parsed valued",parsedvalue);
    if (parsedvalue == nil)
    {
        //NSLog(@"parsedvalue == nil");
        [HUD hide:YES];
    }
    else
    {
        
        NSDictionary* menu = [parsedvalue objectForKey:@"serviceresponse"];
        if ([[menu objectForKey:@"servicename"] isEqualToString:@"Signupupdate"])
        {
            if ([[menu objectForKey:@"success"] isEqualToString:@"Yes"])
            {
                
                NSLog(@"Updation  Succecssful");
                
                [HUD hide:YES];
          
                
                
                //                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                //                {
                //                    UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"Welcome_iPad" bundle:nil];
                //                    UIViewController *initialvc=[welcome instantiateInitialViewController];
                //                    [self.navigationController pushViewController:initialvc animated:YES];
                //                }
                //                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                //                {
                //                    UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"Welcome_iPhone" bundle:nil];
                //                    UIViewController *initialvc=[welcome instantiateInitialViewController];
                //                    [self.navigationController pushViewController:initialvc animated:YES];
                //                }
            }
            else if ([[menu objectForKey:@"success"] isEqualToString:@"No"])
                
            {
                [HUD hide:YES];
                
                    NSLog(@"Updation failed");
                
                
            }
            
        }
    }
    
}
-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Signup.php?service=signupupdate";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&lastname=%@&username=%@&emailid=%@&password=%@&interested=%@&gender=%@&id=%@&%@=%@",firstEntity,value1,lname.text,username.text,email.text,password.text,interestedval,genderval,[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"],secondEntity,value2];
    //  NSLog(@"POST %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    return [du returndbresult:post URL:url];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == username)
    {
        NSString *rangeOfString = @" ";
        NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
        if(![string isEqualToString:@""])
        {
            if (range.location == 0 && [rangeOfCharacters characterIsMember:[string characterAtIndex:0]] )
            {
                
                return NO;
            }
        }
    }
    else if(textField == password)
    {
        NSString *rangeOfString = @" ";
        NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
        if(![string isEqualToString:@""])
        {
            if (range.location == 0 && [rangeOfCharacters characterIsMember:[string characterAtIndex:0]] )
            {
                
                return NO;
            }
        }
    }
   
    else if (textField == fname)
    {
        NSString *rangeOfString = @" ";
        NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
        //        for (int i = 0; i<[string length]; i++)
        //        {
        //            UniChar c1 = [string characterAtIndex:i];
        //            if ([rangeOfCharacters characterIsMember:c1])
        //            {
        //                return NO;
        //            }
        //        }
        if(![string isEqualToString:@""])
        {
            if (range.location == 0 && [rangeOfCharacters characterIsMember:[string characterAtIndex:0]] )
            {
                
                return NO;
            }
        }
        
    }
    else if (textField == lname)
    {
        NSString *rangeOfString = @" ";
        NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
        //        for (int i = 0; i<[string length]; i++)
        //        {
        //            UniChar c1 = [string characterAtIndex:i];
        //            if ([rangeOfCharacters characterIsMember:c1])
        //            {
        //                return NO;
        //            }
        //        }
        if(![string isEqualToString:@""])
        {
            if (range.location == 0 && [rangeOfCharacters characterIsMember:[string characterAtIndex:0]] )
            {
                
                return NO;
            }
        }
        
    }
    else if(textField == email)
    {
        NSString *rangeOfString = @" ";
        NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
        if(![string isEqualToString:@""])
        {
            if (range.location == 0 && [rangeOfCharacters characterIsMember:[string characterAtIndex:0]] )
            {
                
                return NO;
            }
        }
        
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)genderact:(id)sender {
    if ([sender selectedSegmentIndex]==0) {
    genderval=@"male";
    }
    else if ([sender selectedSegmentIndex]==1) {
        genderval=@"female";
    }
     [delegate.Profiledetails setValue:genderval forKey:@"gender"];
 
}
- (IBAction)interested:(id)sender {
    if ([sender selectedSegmentIndex]==0) {
        interestedval=@"subject";
    }
    else if ([sender selectedSegmentIndex]==1) {
        interestedval=@"courses";
    }
}
- (IBAction)changepwd:(id)sender {
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
//        Password_ipadViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PasswordChange"];
//        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
//        loginVC.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
//        [self presentViewController:loginVC animated:YES completion:nil];
        Passwordchange *mpvc=[Passwordchange alloc];
        
        mpvc=[mpvc initWithFrame:CGRectMake(0,0,1024,1024)];
          mpvc.transform = CGAffineTransformMakeRotation(4.71);
     
    }
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        Passwordchange *mpvc=[Passwordchange alloc];
        
        
        mpvc=[mpvc initWithFrame:CGRectMake(0,0,320,568)];
    }
   
   
}

- (void)dealloc {
    
    [_saveprofile release];
    [super dealloc];
}
@end



