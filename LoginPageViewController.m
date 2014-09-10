//
//  LoginPageViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 09/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "LoginPageViewController.h"
#import "databaseurl.h"
#import "SBJSON.h"
#import "MBProgressHUD.h"
#import "lmsmoocAppDelegate.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface LoginPageViewController ()
{
    MBProgressHUD *HUD;
    databaseurl *du;
}
@end

@implementation LoginPageViewController
@synthesize username;
@synthesize password;
@synthesize reminder;
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
    NSString *keepmeres=[[NSUserDefaults standardUserDefaults]objectForKey:@"keepmesign"];
    if ([keepmeres isEqualToString:@"1"]) {
        username.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        password.text=@"arul@123";
        reminder.selected=YES;
        [reminder setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
       
    }
    else{
        username.text=@"";
        password.text=@"";
        reminder.selected=NO;
         [reminder setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    }
   
    du=[[databaseurl alloc]init];
    UITapGestureRecognizer *get=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:get];
  
}
-(void)dismissKeyboard
{
    [username resignFirstResponder];
    
    [password resignFirstResponder];
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)forgotpassword:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://208.109.248.89:8085/OnlineCourse/Student/signup" ]];
}
- (IBAction)login:(id)sender
{
    int c=1;
    [self dismissKeyboard];
    if (([username.text length]==0) &&
        ([password.text length]==0))
    {
        c=0;
       
    }
    else if (([username.text length]>0) &&
             ([password.text length]==0))
        
    {
        c=0;
        NSLog(@"Enter password");
        
        
    }
    
    
    else if (([username.text length]==0) &&
             ([password.text length]>0))
    {
        c=0;
        NSLog(@"Enter usrname");
        
    }
    else
    {
        if (([username.text length]>0)&&([password.text length]>0))
        {
            c=1;
            if (c==1)
                
            {
                HUD = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
                HUD.mode=MBProgressHUDModeIndeterminate;
                HUD.delegate = self;
                HUD.labelText = @"Please wait";
                [HUD show:YES];
                if ([[du submitvalues]isEqualToString:@"Success"])
                {
                    [self checkdata];
                }
                else
                {
                    //[HUD hide:YES];
                    HUD.labelText = @"Check network connection";
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
                    HUD.mode = MBProgressHUDModeCustomView;
                    [HUD hide:YES afterDelay:1];
                }
                
            }
            
        }
    }
 
}
- (IBAction)checkbox:(UIButton*)sender {
    
    sender.selected = !sender.selected;
    if(sender.selected){
        [sender setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
    }
    else{
        [sender setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)checkdata
{
    NSString *response=[self HttpPostEntityFirst1:@"username" ForValue1:username.text  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
    NSError *error;
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *parsedvalue = [json objectWithString:response error:&error];
    
    //NSLog(@"%@ parsedvalue",parsedvalue);
    if (parsedvalue == nil)
    {
        
        //NSLog(@"parsedvalue == nil");
        
    }
    else
    {
        
        NSDictionary* menu = [parsedvalue objectForKey:@"serviceresponse"];
        if ([[menu objectForKey:@"servicename"] isEqualToString:@"Login Data"])
        {
            if ([[menu objectForKey:@"success"] isEqualToString:@"Yes"])
            {
                [HUD hide:YES];
                
                [[NSUserDefaults standardUserDefaults]setValue:username.text forKey:@"username"];
                [[NSUserDefaults standardUserDefaults]setValue:[menu objectForKey:@"userid"] forKey:@"userid"];
                NSString *firstname=[menu objectForKey:@"firstname"];
                NSString *lastname=[menu objectForKey:@"lastname"];
                NSString *email=[menu objectForKey:@"email"];
                NSString *interested_in=[menu objectForKey:@"interested_in"];
                NSString *gender=[menu objectForKey:@"gender"];
                NSString *avatarURL=[menu objectForKey:@"avatarURL"];
                NSString *avatarImage=[menu objectForKey:@"avatarImage"];
                NSString *logins=[menu objectForKey:@"logins"];
                NSString *username1=[menu objectForKey:@"username"];
                NSString *password1=[menu objectForKey:@"password"];

                lmsmoocAppDelegate *delegate=AppDelegate;
                delegate.avatharimage=[NSString stringWithFormat:@"%@%@",avatarURL,avatarImage];
                delegate.av_image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:delegate.avatharimage]]];
                

              
                if (reminder.selected) {
                  [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"keepmesign"];
//                    password.text=@"";
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"keepmesign"];
//                username.text=@"";
//                password.text=@"";
                }
                  [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginComplete"
                                                                    object:self
                                                                  userInfo:nil];
                
            [self dismiss:self];
                
                
            }
            else if ([[menu objectForKey:@"success"] isEqualToString:@"No"])
                
            {
                
                
                [HUD hide:YES];
                NSLog(@"invalid username or password");
                
                username.text=@"";
                password.text=@"";
                
            }
            
        }
    }
    
}
-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Login.php?service=login";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&password=%@&%@=%@",firstEntity,value1,password.text,secondEntity,value2];
    NSURL *url = [NSURL URLWithString:url2];
    
    return [du returndbresult:post URL:url];
}



@end
