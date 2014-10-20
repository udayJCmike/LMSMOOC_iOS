//
//  AboutcourseViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 22/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lmsmoocAppDelegate.h"
#import "databaseurl.h"
#import "MBProgressHUD.h"
#import "UIButton+Bootstrap.h"
#import "SBJSON.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface AboutcourseViewController : UIViewController<MBProgressHUDDelegate>
{
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
    MBProgressHUD *HUD;
}
@property(nonatomic,retain)IBOutlet UITextView *course_des;
@property (retain, nonatomic) IBOutlet UIButton *removefromfav;

@end
