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
@interface SignupViewController ()
{
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
    
    UITapGestureRecognizer *get=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:get];
    // Do any additional setup after loading the view.
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
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://208.109.248.89:8085/OnlineCourse/user_view_Termsofuses" ]];
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
                                if ([du validatePasswordForSignupPage:cpassword.text])
                                {
                                if ([password.text isEqualToString:cpassword.text])
                                {
                                    if (terms.selected) {
                                        c=1;
                                    }
                                    else
                                    {
                                        c=0;
                                       NSLog(@"Please agree to the terms of services.");
                                    }
                                    
                                }
                                else
                                {
                                    c = 0;
                                    // enter mobile TextField
                                    NSLog(@"Password mismatch");
                                    
                                }
                               
                                }
                                else
                                {
                                    c = 0;
                                    // enter organization TextField
                                    NSLog(@"ENTER VALID confirm password");
                                    
                                }
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
        if ([[menu objectForKey:@"servicename"] isEqualToString:@"Signup"])
        {
            if ([[menu objectForKey:@"success"] isEqualToString:@"Yes"])
            {
               
               NSLog(@"Inserting  Succecssful");
              
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
                if ([response isEqualToString:@"emailexist"]) {
                
                    NSLog(@"email exist");
                }
                else if ([response isEqualToString:@"usernameexist"]) {
                    
                    NSLog(@"username exist");
                }
                else
                {
                    NSLog(@"signup failed");
                }
               
            }
            
        }
    }
    
}
-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Signup.php?service=signup";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&lastname=%@&username=%@&emailid=%@&password=%@&cpassword=%@&%@=%@",firstEntity,value1,lname.text,username.text,email.text,password.text,cpassword.text,secondEntity,value2];
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

- (void)dealloc {
    [_signup release];
    [_back release];
    [super dealloc];
}
@end
