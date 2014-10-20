//
//  LikeButtonDemoViewController.h
//  LikeButtonDemo
//
//  Created by Tom Brow on 6/27/11.
//  Copyright 2011 Yardsellr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "REFrostedViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "MTPopupWindow.h"
@interface FacebookLikeViewDemoViewController : UIViewController<MBProgressHUDDelegate,MTPopupWindowDelegate>
{
    MBProgressHUD *HUD;
}
@property (retain, nonatomic) IBOutlet UIButton *terms;
@property (retain, nonatomic) IBOutlet UIButton *privacy;
@property (retain, nonatomic) IBOutlet UIButton *whylearnterest;
@end
