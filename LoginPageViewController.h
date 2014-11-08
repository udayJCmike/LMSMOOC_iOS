//
//  LoginPageViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 09/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginPageViewController : UIViewController<MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *reminder;
@property (retain, nonatomic) IBOutlet UIButton *login;
@property (retain, nonatomic) IBOutlet UIButton *back;
@property (retain, nonatomic) IBOutlet UIView *bg;
-(void)checkdataForLogin;
@end
