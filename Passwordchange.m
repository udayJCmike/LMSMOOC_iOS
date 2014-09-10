//
//  Passwordchange.m
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "Passwordchange.h"

@implementation Passwordchange



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        popUpView  = [[UIView alloc] initWithFrame:CGRectMake(30,30,260,420)];
        
       
        
        cur_pwd  = [[UITextField alloc] initWithFrame:CGRectMake(45, 30, 200, 40)];
        cur_pwd.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
        cur_pwd.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
        cur_pwd.backgroundColor=[UIColor whiteColor];
        cur_pwd.text=@"Hello World";
       
        cfm_pwd = [[UITextField alloc] initWithFrame:CGRectMake(65, 60, 200, 40)];
        cfm_pwd.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
        cfm_pwd.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
        cfm_pwd.backgroundColor=[UIColor whiteColor];
        cfm_pwd.text=@"Hello World";
        
        new_pwd = [[UITextField alloc] initWithFrame:CGRectMake(95, 90, 200, 40)];
        new_pwd.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
        new_pwd.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
        new_pwd.backgroundColor=[UIColor whiteColor];
        new_pwd.text=@"Hello World";
        
        CGRect btnTempFrame=CGRectMake(5, 385, 90, 30);
        getpwd=[[UIButton alloc]initWithFrame:btnTempFrame];
//        [btnTemp setBackgroundImage:[UIImage imageNamed:@"btn_plain_iphone.png"] forState:UIControlStateNormal];
        [getpwd.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [getpwd.titleLabel setTextColor:[UIColor whiteColor]];
        [getpwd.titleLabel setText:@"Get Password"];
        [getpwd addTarget:self action:@selector(changePassword:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        CGRect closeButtonFrame=CGRectMake(195, 385, 60, 30);
        close=[[UIButton alloc]initWithFrame:closeButtonFrame];
       // [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_plain_iphone.png"] forState:UIControlStateNormal];
        [close.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [close.titleLabel setTextColor:[UIColor whiteColor]];
        [close setTitle:@"Close" forState:UIControlStateNormal];
        [close addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect swipeLabelFrame=CGRectMake(0, 0, 140, 15);
       label1=[[UILabel alloc]initWithFrame:swipeLabelFrame];
        
        [label1 setBackgroundColor:[UIColor clearColor]];
        [label1 setText:@"Current Password"];
        [label1 setTextColor:[UIColor lightGrayColor]];
        [label1 setFont:[UIFont systemFontOfSize:12]];
        
        CGRect dateLabelFrame=CGRectMake(5, 365, 100, 15);
        label2=[[UILabel alloc]initWithFrame:dateLabelFrame];
        
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label2 setText:@"New Password"];
        [label2 setTextColor:[UIColor whiteColor]];
        [label2 setFont:[UIFont systemFontOfSize:13]];
        
        CGRect priceLabelFrame=CGRectMake(155, 365, 100, 15);
        label3=[[UILabel alloc]initWithFrame:priceLabelFrame];
        
        [label3 setBackgroundColor:[UIColor clearColor]];
        [label3 setText:@"Confirm Password"];
        [label3 setTextColor:[UIColor colorWithRed:71.0/255 green:191.0/255 blue:226.0/255 alpha:1]];
        [label3 setFont:[UIFont systemFontOfSize:13]];
        [label3 setTextAlignment:NSTextAlignmentRight];
        
        
        
       
        
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
    
}
@end
