//
//  AboutauthorViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 22/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lmsmoocAppDelegate.h"
#import "MBProgressHUD.h"
#import "databaseurl.h"
#import "SBJSON.h"

#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface AboutauthorViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
    NSString *follow;
}
@property(nonatomic,retain)IBOutlet UILabel *authorname;
@property(nonatomic,retain)IBOutlet UILabel *edu;
@property(nonatomic,retain)IBOutlet UITextView *aboutme;
@property(nonatomic,retain)IBOutlet UIImageView *avatar;
@property(nonatomic,retain)IBOutlet UIButton *followbutton;
@property (retain, nonatomic)  NSOperationQueue *imageOperationQueue;
@property (retain, nonatomic)    NSCache *imageCache;
@end
