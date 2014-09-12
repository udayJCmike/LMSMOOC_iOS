//
//  Passwordchange.h
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "databaseurl.h"
#import "lmsmoocAppDelegate.h"
#import "APRoundedButton.h"
@interface Passwordchange : UIView<UITextFieldDelegate>
{
    UIView *popUpView;
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UITextField *cur_pwd;
    UITextField *cfm_pwd;
    UITextField *new_pwd;
    APRoundedButton *close;
    APRoundedButton *getpwd;
    databaseurl *du;
     lmsmoocAppDelegate *delegate;
    
}
@end
