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
                                            [self ShowAlert:@"Please agree to the terms of services."];
                                                                               // NSLog(@"Please agree to the terms of services.");
                                    }
                                    
                                }
                                else
                                {
                                    c = 0;
                                   
                                        [self ShowAlert:@"Password and Confirm Password should be same."];
                                        
                                    
                                  //  NSLog(@"Password mismatch");
                                    
                                }
                               
                                }
                                else
                                {
                                    c = 0;
                                    if ([cpassword.text length]==0) {
                                        [self ShowAlert:@"Enter the confirm password."];
                                    }
                                    else
                                    {
                                        [self ShowAlert:@"Password and Confirm Password should be same."];
                                        
                                    }
                                  //  NSLog(@"ENTER VALID confirm password");
                                    
                                }
                            }
                            else
                            {
                                c = 0;
                                if ([password.text length]==0) {
                                    [self ShowAlert:@"Enter the password."];
                                }
                                else
                                {
                                   [self ShowAlert:@"Should contain 1 alphabet.\nShould contain 1 number.\nShould contain 1 special character.\nShould be 8 to 25 characters."];
                                    
                                }
                              //  NSLog(@"ENTER VALID password");
                                
                            }
                    }
                    else
                    {
                        c = 0;
                        if ([email.text length]==0) {
                            [self ShowAlert:@"Enter the email ID."];
                        }
                        else
                        {
                            [self ShowAlert:@"Should contain alphabets.\nShould contain numbers.\nShould contain 1 special character.\nShould be 10 to 40 characters."];
                            
                        }
                         // NSLog(@"ENTER VALID email id");
                      
                    }
                }
                else
                {
                    c = 0;
                    if ([username.text length]==0) {
                        [self ShowAlert:@"Enter the username."];
                    }
                    else
                    {
                        [self ShowAlert:@"Should contain alphabets.\nShould contain numbers.\nShould contain special characters @_-.\nShould be 6 to 25 characters."];
                        
                    }
                      NSLog(@"ENTER VALID username");
                    
                }
            }
            else
            {
                c=0;
                if ([lname.text length]==0) {
                    [self ShowAlert:@"Enter the lastname."];
                }
                else
                {
                    [self ShowAlert:@"Should contain alphabets.\nShould be 3 to 15 characters."];
                    
                }
                // NSLog(@"ENTER VALID LAST NAME");
               
            }
        }
        else
        {
            c=0;
            if ([fname.text length]==0) {
                [self ShowAlert:@"Enter the firstname."];
            }
            else
            {
                [self ShowAlert:@"Should contain alphabets.\nShould be 3 to 15 characters."];
            
            }
           //  NSLog(@"ENTER VALID FIRST NAME");
           
        }
    }
    else
    {
        c=0;
          [self ShowAlert:@"Enter all fields."];
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
-(void)ShowAlert:(NSString*)message
{
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"Info" contentText:[NSString stringWithFormat:@"%@",message] leftButtonTitle:nil rightButtonTitle:@"Close"];
    [alert show];
    alert.rightBlock = ^() {
        
    };
    alert.dismissBlock = ^() {
        
    };
    
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
   NSString *first= [fname.text stringByReplacingOccurrencesOfString:@" " withString:@""];
   first= [first uppercaseString];
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
                
                     [self ShowAlert:@"Email id exist."];
                }
                else if ([response isEqualToString:@"usernameexist"]) {
                    
                     [self ShowAlert:@"Username exist."];
                }
                else
                {
                      [self ShowAlert:@"Signup failed."];
                }
               
            }
            
        }
    }
    
}
-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    NSString *second= [lname.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    second= [second uppercaseString];
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
                        [self ShowAlert:@"Enter the firstname."];
                    }
                    else
                    {
                        [self ShowAlert:@"Should contain only alphabets.\nShould be 3 to 15 characters."];
                        
                    }
                   
                    
                }
            break;
        case 2:
            if ([du validateNameForSignupPage:lname.text])
            {
            }
            else
            {
                
                if ([lname.text length]==0) {
                    [self ShowAlert:@"Enter the lastname."];
                }
                else
                {
                    [self ShowAlert:@"Should contain only alphabets.\nShould be 3 to 15 characters."];
                    
                }
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
                        [self ShowAlert:@"Username exist."];
                    }
                }

                
            }
            else
            {
               
                if ([username.text length]==0) {
                    [self ShowAlert:@"Enter the username."];
                }
                else
                {
                    [self ShowAlert:@"Should contain alphabets.\nShould contain numbers.\nShould contain special characters @_-.\nShould be 6 to 25 characters."];
                    
                }
              //  NSLog(@"ENTER VALID username");
                
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
                        [self ShowAlert:@"Email id exist."];
                    }
                }
            }
            else
            {
        
                if ([email.text length]==0) {
                    [self ShowAlert:@"Enter the email ID."];
                }
                else
                {
                    [self ShowAlert:@"Should contain alphabets.\nShould contain numbers.\nShould contain 1 special character.\nShould be 10 to 40 characters."];
                    
                }
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
                    [self ShowAlert:@"Enter the password."];
                }
                else
                {
                    [self ShowAlert:@"Should contain 1 alphabet.\nShould contain 1 number.\nShould contain 1 special character.\nShould be 8 to 25 characters."];
                    
                }
                //  NSLog(@"ENTER VALID password");
                
            }
            break;
        case 6:
            if ([password.text isEqualToString:cpassword.text])
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
- (void)dealloc {
    [_signup release];
    [_back release];
    [super dealloc];
}
@end
