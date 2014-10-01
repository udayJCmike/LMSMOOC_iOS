//
//  SignupViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 09/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SignupViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UIButton *terms;
@property (strong, nonatomic) IBOutlet UITextField *fname;
@property (strong, nonatomic) IBOutlet UITextField *lname;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *cpassword;
@property (retain, nonatomic) IBOutlet UIButton *signup;
@property (retain, nonatomic) IBOutlet UIButton *back;
@property (retain, nonatomic) IBOutlet UIView *bg;

@end
