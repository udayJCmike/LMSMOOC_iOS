//
//  AudioPlayerViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 24/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lmsmoocAppDelegate.h"
#import "MBProgressHUD.h"
#import "databaseurl.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface AudioPlayerViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
}
@end
