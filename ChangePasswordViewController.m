//
//  ChangePasswordViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 20/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController
@synthesize cfm_pwd;
@synthesize cur_pwd;
@synthesize new_pwd;
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
    [self.getpassword primaryStyle];
    du=[[databaseurl alloc]init];
    delegate=AppDelegate;
     cur_pwd.text=[delegate.Profiledetails objectForKey:@"password"];
    NSLog(@"password %@",[delegate.Profiledetails objectForKey:@"password"]);
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *get=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:get];
  
    if (self.navigationController.navigationBar.hidden == YES)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
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
}
    - (void)menulistener:(id)sender {
        
        
        
        [self.view endEditing:YES];
        [self.frostedViewController.view endEditing:YES];
        [self.frostedViewController presentMenuViewController];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Showmenu" object:nil];
    }
    -(void)dismissKeyboard
    {
        [cur_pwd resignFirstResponder];
          [new_pwd resignFirstResponder];
          [cfm_pwd resignFirstResponder];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changePassword:(id)sender
{
   
    int c=1;
    if ([du validatePasswordForSignupPage:new_pwd.text])
    {
        if ([du validatePasswordForSignupPage:cfm_pwd.text])
        {
            if ([new_pwd.text isEqualToString:cfm_pwd.text])
            {
                [delegate.Profiledetails setValue:new_pwd.text forKey:@"password"];
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
            else
            {
                c = 0;
                [self ShowAlert:@"Password and Confirm Password should be same."];
                
            }
        }
        else
        {
            c = 0;
            if ([cfm_pwd.text length]==0) {
                [self ShowAlert:@"Enter the password."];
            }
            else
            {
                [self ShowAlert:@"Should contain 1 alphabet.\nShould contain 1 number.\nShould contain 1 special character.\nShould be 8 to 25 characters."];
                
            }

            
        }
    }
    else
    {
        c = 0;
        if ([new_pwd.text length]==0) {
            [self ShowAlert:@"Enter the password."];
        }
        else
        {
            [self ShowAlert:@"Should contain 1 alphabet.\nShould contain 1 number.\nShould contain 1 special character.\nShould be 8 to 25 characters."];
            
        }

        
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == cur_pwd)
    {
        NSString *rangeOfString = @" ";
        NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
        if(![string isEqualToString:@""])
        {
            if (range.location == 0 && [rangeOfCharacters characterIsMember:[string characterAtIndex:0]] )
            {
                
                return NO;
            }
            for (int i = 0; i<[string length]; i++)
            {
                UniChar c1 = [string characterAtIndex:i];
                if ([rangeOfCharacters characterIsMember:c1])
                {
                    return NO;
                }
            }
        }
    }
    else if(textField == new_pwd)
    {
        NSString *rangeOfString = @" ";
        NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
        if(![string isEqualToString:@""])
        {
            if (range.location == 0 && [rangeOfCharacters characterIsMember:[string characterAtIndex:0]] )
            {
                
                return NO;
            }
            for (int i = 0; i<[string length]; i++)
            {
                UniChar c1 = [string characterAtIndex:i];
                if ([rangeOfCharacters characterIsMember:c1])
                {
                    return NO;
                }
            }
        }
    }
    
    else if(textField == cfm_pwd)
    {
        NSString *rangeOfString = @" ";
        NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
        if(![string isEqualToString:@""])
        {
            if (range.location == 0 && [rangeOfCharacters characterIsMember:[string characterAtIndex:0]] )
            {
                
                return NO;
            }
            for (int i = 0; i<[string length]; i++)
            {
                UniChar c1 = [string characterAtIndex:i];
                if ([rangeOfCharacters characterIsMember:c1])
                {
                    return NO;
                }
            }
        }
    }
    return YES;
    
}
-(void)ShowAlert:(NSString*)message
{
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"Info" contentText:[NSString stringWithFormat:@"%@",message] leftButtonTitle:nil rightButtonTitle:@"Close"];
    [alert show];
    alert.rightBlock = ^() {
        
    };
    alert.dismissBlock = ^() {
        
    };
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"tag number %d",textField.tag);
    switch (textField.tag) {
        case 1:
            if ([du validatePasswordForSignupPage:cur_pwd.text])
            {
            }
            else
            {
                if ([cur_pwd.text length]==0) {
                    [self ShowAlert:@"Enter the password."];
                }
                else
                {
                    [self ShowAlert:@"Should contain 1 alphabet.\nShould contain 1 number.\nShould contain 1 special character.\nShould be 8 to 25 characters."];
                    
                }
                //  NSLog(@"ENTER VALID password");
                
            }
            break;
        case 2:
            if ([du validatePasswordForSignupPage:new_pwd.text])
            {
            }
            else
            {
                if ([new_pwd.text length]==0) {
                    [self ShowAlert:@"Enter the password."];
                }
                else
                {
                    [self ShowAlert:@"Should contain 1 alphabet.\nShould contain 1 number.\nShould contain 1 special character.\nShould be 8 to 25 characters."];
                    
                }
                //  NSLog(@"ENTER VALID password");
                
            }
            break;
        case 3:
            if ([new_pwd.text isEqualToString:cfm_pwd.text])
            {
            }
            else
            {
                
                
                [self ShowAlert:@"Password and Confirm Password should be same."];
                
                
                //  NSLog(@"Password mismatch");
                
            }
            break;
            
        default:
            break;
    }
}

-(void)signupdata
{
   
    NSString *username=[[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    NSString *response=[self HttpPostEntityFirst1:@"username" ForValue1:username  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
    
    NSError *error;
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *parsedvalue = [json objectWithString:response error:&error];
    
     NSLog(@"%@ parsed valued",parsedvalue);
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
                cfm_pwd.text=@"";
                new_pwd.text=@"";
               cur_pwd.text=[delegate.Profiledetails objectForKey:@"password"];
                
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
   
    NSString *userid=[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Signup.php?service=Passwordupdate";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&id=%@&password=%@&%@=%@",firstEntity,value1,userid,new_pwd.text,secondEntity,value2];
     NSLog(@"POST %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    return [du returndbresult:post URL:url];
}

-(void)dealloc
{
    [super dealloc];
    HUD.delegate = nil;
}
@end
