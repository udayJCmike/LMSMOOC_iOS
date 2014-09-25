//
//  VideoPlayerViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 24/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lmsmoocAppDelegate.h"
#import "MBProgressHUD.h"
#import "databaseurl.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>

#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface VideoPlayerViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
}

@property(nonatomic,retain)NSString *videoname;
@property (strong, nonatomic) MPMoviePlayerController *videoPlayer;
@property (strong, nonatomic) MPMoviePlayerViewController *videoViewController;
@end
