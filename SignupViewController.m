//
//  SignupViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 09/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "SignupViewController.h"
#import "MBProgressHUD.h"
#import "databaseurl.h"
#import "JSON.h"
#import "UIButton+Bootstrap.h"
#import "DXAlertView.h"
#import "lmsmoocAppDelegate.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface SignupViewController ()
{
       lmsmoocAppDelegate *delegate;
    databaseurl *du;
    MBProgressHUD *HUD;
}
@end

@implementation SignupViewController
@synthesize fname;
@synthesize lname;
@synthesize username;
@synthesize email;
@synthesize password;
@synthesize cpassword;
@synthesize terms;
@synthesize bg;
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
    [self.back defaultStyle];
    [self.signup primaryStyle];

    du=[[databaseurl alloc]init];
    fname.delegate = self;
    lname.delegate=self;
    username.delegate=self;
    password.delegate = self;
    cpassword.delegate=self;
    email.delegate=self;
    delegate=AppDelegate;
    [self performSelector:@selector(downloadURL) withObject:self afterDelay:0.0f];
    UITapGestureRecognizer *get=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:get];
    bg.layer.cornerRadius=10;
    bg.layer.masksToBounds=YES;
    // Do any additional setup after loading the view.
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
    [fname resignFirstResponder];
    [lname resignFirstResponder];
    [username resignFirstResponder];
    [email resignFirstResponder];
    [cpassword resignFirstResponder];
    [password resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)termsOfservice:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user_view_Termsofuses",delegate.common_url]]];
}
- (IBAction)signup:(id)sender {
    int c=1;
    [self dismissKeyboard];
    if (fname.text.length>0 &&
        lname.text.length>0 &&
        username.text.length>0 &&
        password.text.length>0 &&
        cpassword.text.length>0 &&
        email.text.length>0 )
    {
        
        if (terms.selected) {
            c=1;
        }
        else
        {
            c=0;
            [self ShowAlert:@"Please agree to the terms of services."title:@"Sorry User"];
            // NSLog(@"Please agree to the terms of services.");
        }

        
    /*    if ([du validateNameForSignupPage:fname.text])
        {
            if ([du validateNameForSignupPage:lname.text])
            {
     
                    if ([du validateUserNameForSignupPage:username.text])
                    {
                        if ([du validateEmailForSignupPage:email.text])
                        {
                            if ([du validatePasswordForSignupPage:password.text])
                            {
                                if ([cpassword.text length]>0)
                                {
                                if ([password.text isEqualToString:cpassword.text])
                                {
                                    if (terms.selected) {
                                        c=1;
                                    }
                                    else
                                    {
                                        c=0;
                                            [self ShowAlert:@"Please agree to the terms of services."title:@"Sorry User"];
                                                                               // NSLog(@"Please agree to the terms of services.");
                                    }
                                    
                                }
                                else
                                {
                                    c = 0;
                                   
                                        [self ShowAlert:@"Password do not match."title:@"Sorry User"];
                                        
                                    
                                  //  NSLog(@"Password mismatch");
                                    
                                }
                               
                                }
                                else
                                {
                                    c = 0;
                                    if ([cpassword.text length]==0) {
                                        [self ShowAlert:@"Enter confirm password."title:@"Sorry User"];
                                    }
                                    else
                                    {
                                       // [self ShowAlert:@"Should contain 1 alphabet.\nShould contain 1 number.\nShould contain 1 special character.\nShould be 8 to 25 characters."title:@"Sorry User"];
                                        [self ShowAlert:@"Enter a valid confirm password."title:@"Sorry User"];
                                        
                                    }
                                  //  NSLog(@"ENTER VALID confirm password");
                                    
                                }
                            }
                            else
                            {
                                c = 0;
                                if ([password.text length]==0) {
                                    [self ShowAlert:@"Enter password."title:@"Sorry User"];
                                }
                                else
                                {
                                 //  [self ShowAlert:@"Should contain 1 alphabet.\nShould contain 1 number.\nShould contain 1 special character.\nShould be 8 to 25 characters."title:@"Sorry User"];
                                     [self ShowAlert:@"Enter a valid password."title:@"Sorry User"];
                                    
                                }
                              //  NSLog(@"ENTER VALID password");
                                
                            }
                    }
                    else
                    {
                        c = 0;
                        if ([email.text length]==0) {
                            [self ShowAlert:@"Enter email ID."title:@"Sorry User"];
                        }
                        else
                        {
                           // [self ShowAlert:@"Should contain alphabets.\nShould contain numbers.\nShould contain 1 special character.\nShould be 10 to 40 characters."title:@"Sorry User"];
                                 [self ShowAlert:@"Enter a valid email ID."title:@"Sorry User"];
                            
                        }
                         // NSLog(@"ENTER VALID email id");
                      
                    }
                }
                else
                {
                    c = 0;
                    if ([username.text length]==0) {
                        [self ShowAlert:@"Enter username."title:@"Sorry User"];
                    }
                    else
                    {
                      //  [self ShowAlert:@"Should contain alphabets.\nShould contain numbers.\nShould contain special characters @_-.\nShould be 6 to 25 characters."title:@"Sorry User"];
                          [self ShowAlert:@"Enter a valid username."title:@"Sorry User"];
                        
                    }
                    //  NSLog(@"ENTER VALID username");
                    
                }
            }
            else
            {
                c=0;
                if ([lname.text length]==0) {
                    [self ShowAlert:@"Enter lastname."title:@"Sorry User"];
                }
                else
                {
                  //  [self ShowAlert:@"Should contain alphabets.\nShould be 3 to 15 characters."title:@"Sorry User"];
                     [self ShowAlert:@"Enter a valid lastname."title:@"Sorry User"];
                    
                }
                // NSLog(@"ENTER VALID LAST NAME");
               
            }
        }
        else
        {
            c=0;
            if ([fname.text length]==0) {
                [self ShowAlert:@"Enter firstname."title:@"Sorry User"];
            }
            else
            {
               // [self ShowAlert:@"Should contain alphabets.\nShould be 3 to 15 characters."title:@"Sorry User"];
                 [self ShowAlert:@"Enter a valid firstname."title:@"Sorry User"];
            
            }
           //  NSLog(@"ENTER VALID FIRST NAME");
           
        }
     */
    }
    else
    {
        c=0;
          [self ShowAlert:@"Enter all fields."title:@"Sorry User"];
         // NSLog(@"ENTER ALL REQUIRED FIELDS");
        
        
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
-(void)ShowAlert:(NSString*)message title:(NSString *)title
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
}
-(void)reset
{
    terms.selected=NO;
       [terms setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    fname.text=@"";
       lname.text=@"";
       email.text=@"";
       password.text=@"";
       cpassword.text=@"";
       username.text=@"";
    
    
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

-(void)signupdata
{
   NSString *first= [fname.text capitalizedString];
    NSString *response=[self HttpPostEntityFirst1:@"firstname" ForValue1:first  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
  
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
        if ([[menu objectForKey:@"servicename"] isEqualToString:@"Signup"])
        {
            if ([[menu objectForKey:@"success"] isEqualToString:@"Yes"])
            {
                [[NSUserDefaults standardUserDefaults]setValue:email.text forKey:@"emailid"];
                 [[NSUserDefaults standardUserDefaults]setValue:fname.text forKey:@"firstname"];
                 [[NSUserDefaults standardUserDefaults]setValue:lname.text forKey:@"lastname"];
                [[NSUserDefaults standardUserDefaults]synchronize];
               NSLog(@"Inserting  Succecssful");
               [[NSNotificationCenter defaultCenter] postNotificationName:@"SignupComplete"                                                                    object:self userInfo:nil];
                [HUD hide:YES];
                 [self reset];
                [self back:nil];
               
                
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
                NSString *response=[menu objectForKey:@"emaill"];
                if ([response isEqualToString:@"emailexist"])
                {
                    email.text=@"";
                   
                
                     [self ShowAlert:@"Email id exist." title:@"Sorry User"];
                }
                else if ([response isEqualToString:@"usernameexist"])
                {
                     username.text=@"";
                     [self ShowAlert:@"Username exist." title:@"Sorry User"];
                }
                else
                {
                      [self ShowAlert:@"Signup failed." title:@"Sorry User"];
                }
               
            }
            
        }
    }
    
}
-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    NSString *second= [lname.text capitalizedString];
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Signup.php?service=signup";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&lastname=%@&username=%@&emailid=%@&password=%@&cpassword=%@&%@=%@",firstEntity,value1,second,username.text,email.text,password.text,cpassword.text,secondEntity,value2];
    //  NSLog(@"POST %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    return [du returndbresult:post URL:url];
}
-(NSString *)HttpPostEntityUsername:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Signup.php?service=usernameExist";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&%@=%@",firstEntity,value1,secondEntity,value2];
    //  NSLog(@"POST %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    return [du returndbresult:post URL:url];
}
-(NSString *)HttpPostEntityEmail:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    NSString *second= [lname.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    second= [second uppercaseString];
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Signup.php?service=emailExist";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&%@=%@",firstEntity,value1,secondEntity,value2];
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
    else if(textField == cpassword)
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
        if (textField)
        {
            NSString *rangeOfString = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ";
            NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
            for (int i = 0; i<[string length]; i++)
            {
                UniChar c = [string characterAtIndex:i];
                if (![rangeOfCharacters characterIsMember:c])
                {
                    return NO;
                }
            }
            return YES;
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
        if (textField)
        {
            NSString *rangeOfString = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ";
            NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
            for (int i = 0; i<[string length]; i++)
            {
                UniChar c = [string characterAtIndex:i];
                if (![rangeOfCharacters characterIsMember:c])
                {
                    return NO;
                }
            }
            return YES;
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
            for (int i = 0; i<[string length]; i++)
            {
                UniChar c1 = [string characterAtIndex:i];
                if ([rangeOfCharacters characterIsMember:c1])
                {
                    return NO;
                }
            }
        }
        if (textField)
        {
            NSString *rangeOfString = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@_.";
            NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
            for (int i = 0; i<[string length]; i++)
            {
                UniChar c = [string characterAtIndex:i];
                if (![rangeOfCharacters characterIsMember:c])
                {
                    return NO;
                }
            }
            return YES;
        }
        
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
   
    switch (textField.tag) {
        case 1:
            if ([du validateNameForSignupPage:fname.text])
            {
                
            }
            else
                {
                    
                    if ([fname.text length]==0) {
                        [self ShowAlert:@"Enter firstname." title:@"Sorry User"];
                    }
                    else
                    {
//                        [self ShowAlert:@"Should contain only alphabets.\nShould be 3 to 15 characters."title:@"Sorry User"];
                         [self ShowAlert:@"Enter a valid firstname." title:@"Sorry User"];
                        
                    }
                   
                    fname.text=@"";
                }
            break;
        case 2:
            if ([du validateNameForSignupPage:lname.text])
            {
            }
            else
            {
                
                if ([lname.text length]==0) {
                    [self ShowAlert:@"Enter lastname."title:@"Sorry User"];
                }
                else
                {
//                    [self ShowAlert:@"Should contain only alphabets.\nShould be 3 to 15 characters."title:@"Sorry User"];
                     [self ShowAlert:@"Enter a valid lastname."title:@"Sorry User"];
                    
                }
                lname.text=@"";
                // NSLog(@"ENTER VALID LAST NAME");
                
            }
            break;
        case 3:
            if ([du validateUserNameForSignupPage:username.text])
            {
                HUD = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
                HUD.mode=MBProgressHUDModeIndeterminate;
                HUD.delegate = self;
                HUD.labelText = @"Please wait";
                [HUD show:YES];
                NSString *response=[self HttpPostEntityUsername:@"username" ForValue1:textField.text  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
                
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
                    [HUD hide:YES];
                        if ([[menu objectForKey:@"success"] isEqualToString:@"Yes"])
                        {
                            [HUD hide:YES];
                        }
                    else  if ([[menu objectForKey:@"emaill"] isEqualToString:@"usernameexist"])
                    {
                        username.text=@"";
                        [self ShowAlert:@"Username exist." title:@"Sorry User"];
                    }
                }

                
            }
            else
            {
               
                if ([username.text length]==0) {
                    [self ShowAlert:@"Enter username."title:@"Sorry User"];
                }
                else
                {
                 //   [self ShowAlert:@"Should contain alphabets.\nShould contain numbers.\nShould contain special characters @_-.\nShould be 6 to 25 characters."title:@"Sorry User"];
                      [self ShowAlert:@"Enter a valid username."title:@"Sorry User"];
                    
                }
              //  NSLog(@"ENTER VALID username");
                username.text=@"";
                
            }

            break;
        case 4:
            if ([du validateEmailForSignupPage:email.text])
            {
                HUD = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
                HUD.mode=MBProgressHUDModeIndeterminate;
                HUD.delegate = self;
                HUD.labelText = @"Please wait";
                [HUD show:YES];
                NSString *response=[self HttpPostEntityEmail:@"email" ForValue1:textField.text  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
                
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
                    [HUD hide:YES];
                    if ([[menu objectForKey:@"success"] isEqualToString:@"Yes"])
                    {
                        [HUD hide:YES];
                    }
                    else  if ([[menu objectForKey:@"emaill"] isEqualToString:@"emailexist"])
                    {
                        email.text=@"";
                        [self ShowAlert:@"Email id exist."title:@"Sorry User"];
                    }
                }
            }
            else
            {
        
                if ([email.text length]==0) {
                    [self ShowAlert:@"Enter email id."title:@"Sorry User"];
                }
                else
                {
                   // [self ShowAlert:@"Should contain alphabets.\nShould contain numbers.\nShould contain 1 special character.\nShould be 10 to 40 characters."title:@"Email id"];
                      [self ShowAlert:@"Enter a valid email id."title:@"Sorry User"];
                    
                }
                email.text=@"";
                // NSLog(@"ENTER VALID email id");
                
            }
            break;
        case 5:
            if ([du validatePasswordForSignupPage:password.text])
            {
            }
            else
            {
                if ([password.text length]==0) {
                    [self ShowAlert:@"Enter password."title:@"Sorry User"];
                }
                else
                {
                   // [self ShowAlert:@"Should contain 1 alphabet.\nShould contain 1 number.\nShould contain 1 special character.\nShould be 8 to 25 characters."title:@"Password"];
                     [self ShowAlert:@"Enter a valid password."title:@"Sorry User"];
                    
                }
                password.text=@"";
                //  NSLog(@"ENTER VALID password");
                
            }
            break;
        case 6:
           
            if ([cpassword.text length]>0&&[password.text isEqualToString:cpassword.text])
            {
                
            }
            else
            {
                if ([cpassword.text length]==0)
                {
                    [self ShowAlert:@"Enter confirm password."title:@"Sorry User"];
                }
//                else if(![du validatePasswordForSignupPage:cpassword.text])
//                {
//                    
//                    [self ShowAlert:@"Should contain 1 alphabet.\nShould contain 1 number.\nShould contain 1 special character.\nShould be 8 to 25 characters."title:@"Confirm password"];
//                    
//                }
                else if(![password.text isEqualToString:cpassword.text])
                {
                    [self ShowAlert:@"Password do not match."title:@"Sorry User"];
                }
                
                
                
                  cpassword.text=@"";
                //  NSLog(@"Password mismatch");
                
            }

            break;
        default:
            break;
    }
    
    
}
- (void)dealloc {
    [_signup release];
    [_back release];
    [super dealloc];
}
@end
