//
//  Passwordchange.m
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "Passwordchange.h"
#import "APRoundedButton.h"
#import "UIButton+Bootstrap.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]


@implementation Passwordchange



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            delegate=AppDelegate;
            [delegate.Profiledetails objectForKey:@"password"];
            // Initialization code
            popUpView  = [[UIView alloc] initWithFrame:CGRectMake(220,187,585,394)];
//            popUpView.transform = CGAffineTransformMakeRotation(0);
            [popUpView setBackgroundColor:[UIColor whiteColor]];
            
            cur_pwd  = [[UITextField alloc] initWithFrame:CGRectMake(303, 67, 187, 30)];
            cur_pwd.textColor = [UIColor blackColor];
            cur_pwd.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            [cur_pwd.layer setCornerRadius:10.0f];
            cur_pwd.delegate=self;
            cur_pwd.text=[delegate.Profiledetails objectForKey:@"password"];
            cur_pwd.secureTextEntry=YES;
            cur_pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
            cur_pwd.layer.borderWidth = 1;
            cur_pwd.layer.borderColor =[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor];
            
            new_pwd = [[UITextField alloc] initWithFrame:CGRectMake(303, 127, 187, 30)];
            [new_pwd.layer setCornerRadius:10.0f];
            new_pwd.textColor = [UIColor blackColor];
            new_pwd.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            new_pwd.delegate=self;
            new_pwd.secureTextEntry=YES;
            new_pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
            new_pwd.layer.borderWidth = 1;
            new_pwd.layer.borderColor =[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor];
            
            cfm_pwd = [[UITextField alloc] initWithFrame:CGRectMake(303, 194, 187, 30)];
            cfm_pwd.textColor = [UIColor blackColor];
            cfm_pwd.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            [cfm_pwd.layer setCornerRadius:10.0f];
            cfm_pwd.delegate=self;
            cfm_pwd.secureTextEntry=YES;
            cfm_pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
            cfm_pwd.layer.borderWidth = 1;
            cfm_pwd.layer.borderColor =[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor];
            
            
            CGRect btnTempFrame=CGRectMake(105, 280, 170, 30);
            getpwd=[[APRoundedButton alloc]initWithFrame:btnTempFrame];
           // getpwd.style=4;
            [getpwd.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
            [getpwd.titleLabel setTextColor:[UIColor whiteColor]];
            [getpwd setTitle:@"Get Password" forState:UIControlStateNormal];
            [getpwd addTarget:self action:@selector(changePassword:) forControlEvents:UIControlEventTouchUpInside];
            [getpwd setBackgroundColor:[UIColor colorWithRed:61/256.0 green:139/256.0 blue:202/256.0 alpha:1.0]];
            [getpwd setTintColor:[UIColor whiteColor]];
            [getpwd.layer setCornerRadius:5.0f];
            
            
            CGRect closeButtonFrame=CGRectMake(305, 280, 170, 30);
            close=[[APRoundedButton alloc]initWithFrame:closeButtonFrame];
          //  close.style=4;
            [close.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
            [close.titleLabel setTextColor:[UIColor whiteColor]];
            [close setTitle:@"Close" forState:UIControlStateNormal];
            [close addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
            [close setBackgroundColor:[UIColor colorWithRed:127/256.0 green:127/256.0 blue:127/256.0 alpha:1.0]];
            [close setTintColor:[UIColor whiteColor]];
            [close.layer setCornerRadius:5.0f];
            
            CGRect swipeLabelFrame=CGRectMake(95, 67, 187, 29);
            label1=[[UILabel alloc]initWithFrame:swipeLabelFrame];
            [label1 setBackgroundColor:[UIColor clearColor]];
            [label1 setText:@"Current Password"];
            [label1 setTextColor:[UIColor blackColor]];
            [label1 setFont:[UIFont systemFontOfSize:17]];
            
            CGRect dateLabelFrame=CGRectMake(95, 127, 187, 29);
            label2=[[UILabel alloc]initWithFrame:dateLabelFrame];
            [label2 setBackgroundColor:[UIColor clearColor]];
            [label2 setText:@"New Password"];
            [label2 setTextColor:[UIColor blackColor]];
            [label2 setFont:[UIFont systemFontOfSize:17]];
            
            CGRect priceLabelFrame=CGRectMake(95, 194, 187, 29);
            label3=[[UILabel alloc]initWithFrame:priceLabelFrame];
            [label3 setBackgroundColor:[UIColor clearColor]];
            [label3 setText:@"Confirm New Password"];
            [label3 setTextColor:[UIColor blackColor]];
            [label3 setFont:[UIFont systemFontOfSize:17]];
            
        }
        else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            delegate=AppDelegate;
            [delegate.Profiledetails objectForKey:@"password"];
            // Initialization code
            popUpView  = [[UIView alloc] initWithFrame:CGRectMake(30,127,260,300)];
            
            [popUpView setBackgroundColor:[UIColor whiteColor]];
            
            cur_pwd  = [[UITextField alloc] initWithFrame:CGRectMake(20, 49, 220, 30)];
            cur_pwd.textColor = [UIColor blackColor];
            cur_pwd.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            [cur_pwd.layer setCornerRadius:10.0f];
            cur_pwd.delegate=self;
            cur_pwd.text=[delegate.Profiledetails objectForKey:@"password"];
            cur_pwd.secureTextEntry=YES;
            cur_pwd.clearsOnBeginEditing=YES;
            cur_pwd.layer.borderWidth = 1;
            cur_pwd.layer.borderColor =[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor];
            
            new_pwd = [[UITextField alloc] initWithFrame:CGRectMake(20, 116, 220, 30)];
            [new_pwd.layer setCornerRadius:10.0f];
            new_pwd.textColor = [UIColor blackColor];
            new_pwd.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            new_pwd.delegate=self;
            new_pwd.secureTextEntry=YES;
            new_pwd.clearsOnBeginEditing=YES;
            new_pwd.layer.borderWidth = 1;
            new_pwd.layer.borderColor =[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor];
            
            cfm_pwd = [[UITextField alloc] initWithFrame:CGRectMake(20, 178, 220, 30)];
            cfm_pwd.textColor = [UIColor blackColor];
            cfm_pwd.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            [cfm_pwd.layer setCornerRadius:10.0f];
            cfm_pwd.delegate=self;
            cfm_pwd.secureTextEntry=YES;
            cfm_pwd.clearsOnBeginEditing=YES;
            cfm_pwd.layer.borderWidth = 1;
            cfm_pwd.layer.borderColor =[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor];
            
            
            CGRect btnTempFrame=CGRectMake(23, 236, 106, 30);
            getpwd=[[APRoundedButton alloc]initWithFrame:btnTempFrame];
           // getpwd.style=4;
            
            //        [btnTemp setBackgroundImage:[UIImage imageNamed:@"btn_plain_iphone.png"] forState:UIControlStateNormal];
            [getpwd.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [getpwd.titleLabel setTextColor:[UIColor whiteColor]];
            [getpwd setTitle:@"Get Password" forState:UIControlStateNormal];
            [getpwd addTarget:self action:@selector(changePassword:) forControlEvents:UIControlEventTouchUpInside];
            [getpwd setBackgroundColor:[UIColor colorWithRed:66/256.0 green:139/256.0 blue:202/256.0 alpha:1.0]];
            [getpwd setTintColor:[UIColor whiteColor]];
            [getpwd.layer setCornerRadius:5.0f];
            
            
            CGRect closeButtonFrame=CGRectMake(137, 236, 103, 30);
            close=[[APRoundedButton alloc]initWithFrame:closeButtonFrame];
            //close.style=4;
            // [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_plain_iphone.png"] forState:UIControlStateNormal];
            [close.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [close.titleLabel setTextColor:[UIColor whiteColor]];
            [close setTitle:@"Close" forState:UIControlStateNormal];
            [close addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
            [close setBackgroundColor:[UIColor colorWithRed:127/256.0 green:127/256.0 blue:127/256.0 alpha:1.0]];
            [close setTintColor:[UIColor whiteColor]];
            [close.layer setCornerRadius:5.0f];
            CGRect swipeLabelFrame=CGRectMake(20, 20, 158, 21);
            label1=[[UILabel alloc]initWithFrame:swipeLabelFrame];
            
            [label1 setBackgroundColor:[UIColor clearColor]];
            [label1 setText:@"Current Password"];
            [label1 setTextColor:[UIColor blackColor]];
            [label1 setFont:[UIFont systemFontOfSize:16]];
            
            CGRect dateLabelFrame=CGRectMake(20, 87, 129, 21);
            label2=[[UILabel alloc]initWithFrame:dateLabelFrame];
            
            [label2 setBackgroundColor:[UIColor clearColor]];
            [label2 setText:@"New Password"];
            [label2 setTextColor:[UIColor blackColor]];
            [label2 setFont:[UIFont systemFontOfSize:16]];
            
            CGRect priceLabelFrame=CGRectMake(20, 154, 194, 21);
            label3=[[UILabel alloc]initWithFrame:priceLabelFrame];
            [label3 setBackgroundColor:[UIColor clearColor]];
            [label3 setText:@"Confirm New Password"];
            [label3 setTextColor:[UIColor blackColor]];
            [label3 setFont:[UIFont systemFontOfSize:16]];
        }
       
       
        
        
        
        
       
        
        [popUpView addSubview:getpwd];
        [popUpView addSubview:close];
        [popUpView addSubview:label1];
        [popUpView addSubview:label2];
        [popUpView addSubview:label3];
        [popUpView addSubview:cur_pwd];
        [popUpView addSubview:cfm_pwd];
        [popUpView addSubview:new_pwd];
        
        [UIView beginAnimations:@"curlup" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:popUpView cache:YES];
        [self addSubview:popUpView];
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
          
        }
        
        [UIView commitAnimations];
        
        UIColor *color = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        self.backgroundColor = color;
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        
    }
    return self;
}
-(void)closeView:(id)sender
{
    [self removeFromSuperview];
}
-(void)changePassword:(id)sender
{
    du=[[databaseurl alloc]init];
    delegate=AppDelegate;
    int c=1;
    if ([du validatePasswordForSignupPage:new_pwd.text])
    {
        if ([du validatePasswordForSignupPage:cfm_pwd.text])
        {
            if ([new_pwd.text isEqualToString:cfm_pwd.text])
            {
                [delegate.Profiledetails setValue:new_pwd.text forKey:@"password"];
                [self removeFromSuperview];

            }
            else
            {
                c = 0;
                // enter organization TextField
                NSLog(@"ENTER  password mismatch");
                
            }
        }
        else
        {
            c = 0;
            // enter organization TextField
            NSLog(@"ENTER VALID new confirm password");
            
        }
    }
    else
    {
        c = 0;
        // enter organization TextField
        NSLog(@"ENTER VALID new password");
        
    }
 
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)willRemoveSubview:(UIView *)subview {
    NSLog(@"called... removed");
}
@end
