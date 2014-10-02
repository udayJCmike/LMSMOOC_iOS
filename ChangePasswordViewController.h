//
//  ChangePasswordViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 20/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "databaseurl.h"
#import "lmsmoocAppDelegate.h"
#import "DXAlertView.h"
#import "MBProgressHUD.h"
#import "SBJSON.h"
#import "UIButton+Bootstrap.h"
#import "REFrostedViewController.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
    UITextField *cur_pwd;
    UITextField *cfm_pwd;
    UITextField *new_pwd;
    databaseurl *du;
     MBProgressHUD *HUD;
    lmsmoocAppDelegate *delegate;
}
@property(nonatomic,retain)IBOutlet UITextField *cur_pwd;
@property(nonatomic,retain)IBOutlet UITextField *new_pwd;
@property(nonatomic,retain)IBOutlet UITextField *cfm_pwd;

@property(nonatomic,retain)IBOutlet UILabel *cur_pwdlab;
@property(nonatomic,retain)IBOutlet UILabel *new_pwdlab;
@property(nonatomic,retain)IBOutlet UILabel *cfm_pwdlab;
@property(nonatomic,retain)IBOutlet UIButton *getpassword;
@property (retain, nonatomic) IBOutlet UIView *bg;

@end
