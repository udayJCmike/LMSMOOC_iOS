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
       lmsmoocAppDelegate *delegate;
    MBProgressHUD *HUD;
    databaseurl *du;
}
@end

@implementation LoginPageViewController
@synthesize username;
@synthesize password;
@synthesize reminder;
@synthesize bg;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    NSString *keepmeres=[[NSUserDefaults standardUserDefaults]objectForKey:@"keepmesign"];
//    if ([keepmeres isEqualToString:@"1"]) {
//        username.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
//        password.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
//        reminder.selected=YES;
//        [reminder setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
//        
//    }
//    else{
//        username.text=@"";
//        password.text=@"";
//        reminder.selected=NO;
//        [reminder setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.login primaryStyle];
    [self.back defaultStyle];

    
//    NSString *keepmeres=[[NSUserDefaults standardUserDefaults]objectForKey:@"keepmesign"];
//    if ([keepmeres isEqualToString:@"1"]) {
//        username.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
//        password.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
//        reminder.selected=YES;
//        [reminder setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
//       
//    }
//    else{
//        username.text=@"";
//        password.text=@"";
//        reminder.selected=NO;
//         [reminder setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
//    }
   
    du=[[databaseurl alloc]init];
    delegate=AppDelegate;
 
    [self performSelector:@selector(downloadURL) withObject:self afterDelay:0.0f];
    UITapGestureRecognizer *get=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:get];
    bg.layer.cornerRadius=10;
    bg.layer.masksToBounds=YES;
  
}
-(void)downloadURL
{
    
    NSString *response=[self HttpPostEntityFirstURL1:@"name" ForValue1:@"lms"  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
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
        
        if ([[menu objectForKey:@"success"] isEqualToString:@"Yes"])
        {
            delegate.course_image_url=[menu objectForKey:@"courseURL"];
            delegate.avatharURL=[menu objectForKey:@"avatarURL"];
            delegate.course_detail_url=[menu objectForKey:@"coursedetailURL"];
            delegate.common_url=[menu objectForKey:@"CommonUrl"];
            
        }
        
        
    }
    
}
-(NSString *)HttpPostEntityFirstURL1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Login.php?service=URL";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&%@=%@",firstEntity,value1,secondEntity,value2];
    NSURL *url = [NSURL URLWithString:url2];
    
    return [du returndbresult:post URL:url];
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Student/signup",delegate.common_url]]];
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

        [self ShowAlert:@"Enter all fields." title:@"Sorry User"];

      
       
    }
    else if (([username.text length]>0) &&
             ([password.text length]==0))
        
    {
        c=0;
     
       [self ShowAlert:@"Enter password." title:@"Sorry User"];
       
       

        
        
    }
    
    
    else if (([username.text length]==0) &&
             ([password.text length]>0))
    {
        c=0;
        [self ShowAlert:@"Enter username." title:@"Sorry User"];
       
       
        
    }
    
}
-(void)ShowAlert:(NSString*)message title:(NSString *)title
{
   
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
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

//              
//                if (reminder.selected) {
//                  [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"keepmesign"];
////                    password.text=@"";
//                }
//                else
//                {
//                    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"keepmesign"];
////                username.text=@"";
////                password.text=@"";
//                }
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
                  [self ShowAlert:@"Invalid username or password." title:@"Sorry User" ];
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

-(NSString *)HttpPostEntityFirstLogin1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Login.php?service=login";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&password=%@&%@=%@",firstEntity,value1,[[NSUserDefaults standardUserDefaults] valueForKey:@"password"],secondEntity,value2];
    NSURL *url = [NSURL URLWithString:url2];
    
    return [du returndbresult:post URL:url];
}
-(void)checkdataForLogin
{
    du=[[databaseurl alloc]init];
    delegate=AppDelegate;
    NSString *response=[self HttpPostEntityFirstLogin1:@"username" ForValue1:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
    NSError *error;
    
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *parsedvalue = [json objectWithString:response error:&error];
    
   // NSLog(@"%@ parsedvalue",parsedvalue);
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
                
                
                delegate.Profiledetails=[[NSMutableDictionary alloc]init];
                
                
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
                
                
//                if (reminder.selected) {
//                    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"keepmesign"];
//                    //                    password.text=@"";
//                }
//                else
//                {
//                    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"keepmesign"];
//                    //                username.text=@"";
//                    //                password.text=@"";
//                }
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
                [self ShowAlert:@"Invalid username or password." title:@"Sorry User" ];
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                {
                    UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
                    UIViewController *initialvc=[welcome instantiateInitialViewController];
                    delegate.window.rootViewController =initialvc;
                    
                }
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    
                    UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                    UIViewController *initialvc=[welcome instantiateInitialViewController];
                    delegate.window.rootViewController =initialvc;
                    
                }
                
            }
            
        }
    }
    [HUD hide:YES];
}


-(void)dealloc
{
    [super dealloc];
    HUD.delegate = nil;
}
@end
