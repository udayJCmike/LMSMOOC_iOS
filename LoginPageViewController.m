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
#import "UIButton+Bootstrap.h"
#import "DXAlertView.h"
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
    [self.login primaryStyle];
    [self.back defaultStyle];

    
    NSString *keepmeres=[[NSUserDefaults standardUserDefaults]objectForKey:@"keepmesign"];
    if ([keepmeres isEqualToString:@"1"]) {
        username.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        password.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://208.109.248.89:8087/OnlineCourse/Student/signup" ]];
}
- (IBAction)login:(id)sender
{
    int c=1;
    [self dismissKeyboard];
    if (([username.text length]>0)&&([password.text length]>0))
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
        HUD.mode=MBProgressHUDModeIndeterminate;
        HUD.delegate = self;
        HUD.labelText = @"Please wait";
        [HUD show:YES];
        c=1;
        
        if (c==1)
            
        {
//            dispatch_group_t imageQueue = dispatch_group_create();
//            
//            dispatch_group_async(imageQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
//                                 ^{
//                                     
//                                     dispatch_async(dispatch_get_main_queue(), ^{
//                                         
//                                         
//                                     });
//                                 });
            
            if ([[du submitvalues]isEqualToString:@"Success"])
            {
                [self performSelector:@selector(checkdata:) withObject:self afterDelay:0.2f];
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

   else if (([username.text length]==0) &&
        ([password.text length]==0))
    {
        c=0;
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"Info" contentText:@"Enter username and password." leftButtonTitle:nil rightButtonTitle:@"Close"];
        [alert show];
      
       
    }
    else if (([username.text length]>0) &&
             ([password.text length]==0))
        
    {
        c=0;
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"Info" contentText:@"Enter the password." leftButtonTitle:nil rightButtonTitle:@"Close"];
        [alert show];
       
       

        
        
    }
    
    
    else if (([username.text length]==0) &&
             ([password.text length]>0))
    {
        c=0;
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"Info" contentText:@"Enter the username." leftButtonTitle:nil rightButtonTitle:@"Close"];
        [alert show];
       
        
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
-(void)checkdata:(id)sender
{
    NSString *response=[self HttpPostEntityFirst1:@"username" ForValue1:username.text  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
    NSError *error;
    
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *parsedvalue = [json objectWithString:response error:&error];
    
  //  NSLog(@"%@ parsedvalue",parsedvalue);
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
              
                lmsmoocAppDelegate *delegate=AppDelegate;
                delegate.Profiledetails=[[NSMutableDictionary alloc]init];
                
                [[NSUserDefaults standardUserDefaults]setValue:username.text forKey:@"username"];
                  [[NSUserDefaults standardUserDefaults]setValue:password.text forKey:@"password"];
                [[NSUserDefaults standardUserDefaults]setValue:[menu objectForKey:@"firstname"] forKey:@"firstname"];
                [[NSUserDefaults standardUserDefaults]setValue:[menu objectForKey:@"userid"] forKey:@"userid"];
                [delegate.Profiledetails setValue:[menu objectForKey:@"firstname"] forKey:@"firstname"];
                [delegate.Profiledetails setValue:[menu objectForKey:@"lastname"] forKey:@"lastname"];
                [delegate.Profiledetails setValue:[menu objectForKey:@"email"] forKey:@"email"];
                [delegate.Profiledetails setValue:[menu objectForKey:@"interested_in"] forKey:@"interested_in"];
                [delegate.Profiledetails setValue:[menu objectForKey:@"gender"] forKey:@"gender"];
                [delegate.Profiledetails setValue:[menu objectForKey:@"avatarURL"] forKey:@"avatarURL"];
                [delegate.Profiledetails setValue:[menu objectForKey:@"avatarImage"] forKey:@"avatarImage"];
                [delegate.Profiledetails setValue:[menu objectForKey:@"logins"] forKey:@"logins"];
                [delegate.Profiledetails setValue:[menu objectForKey:@"username"] forKey:@"username"];
                [delegate.Profiledetails setValue:[menu objectForKey:@"password"] forKey:@"password"];
                
                 delegate.course_image_url= [menu objectForKey:@"courseimageURL"];
                NSString *avatarURL=[menu objectForKey:@"avatarURL"];
                NSString *avatarImage=[menu objectForKey:@"avatarImage"];
                
//                NSLog(@"values %@",avatarURL);
//                    NSLog(@"values %@", delegate.course_image_url);
                
              
                delegate.avatharURL=avatarURL;
                delegate.av_image=[NSString stringWithFormat:@"%@%@",avatarURL,avatarImage];
                delegate.profileimage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:delegate.av_image]]];

              
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
               // NSLog(@"invalid username or password");
                DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"Sorry User!" contentText:@"Invalid username or password." leftButtonTitle:nil rightButtonTitle:@"Close"];
                [alert show];
                alert.rightBlock = ^() {
                    
                };
                alert.dismissBlock = ^() {
                    
                };
                username.text=@"";
                password.text=@"";
                
            }
            
        }
    }
    [HUD hide:YES];
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



-(void)dealloc
{
    [super dealloc];
    HUD.delegate = nil;
}
@end
