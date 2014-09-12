//
//  ProfileUpdateViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "MBProgressHUD.h"
@interface ProfileUpdateViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSString *genderval,*interestedval;
}
@property (strong, nonatomic) IBOutlet UITextField *fname;
@property (strong, nonatomic) IBOutlet UITextField *lname;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;

@property (retain, nonatomic) IBOutlet UISegmentedControl *interestedin;
@property (retain, nonatomic) IBOutlet UISegmentedControl *gender;
@property (retain, nonatomic) IBOutlet UIButton *saveprofile;

@end
