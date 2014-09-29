//
//  CourseDetailViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 22/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lmsmoocAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"
#import "SyllabusViewController.h"
#import "AboutauthorViewController.h"
#import "AboutcourseViewController.h"
#import "MBProgressHUD.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface CourseDetailViewController : ViewPagerController<ViewPagerDataSource, ViewPagerDelegate,MBProgressHUDDelegate>
{
     lmsmoocAppDelegate *delegate;
    MBProgressHUD *HUD;
}
@property(nonatomic,retain)NSDictionary *SelectedCourse;
@property(nonatomic,retain)IBOutlet UILabel *coursename;
@property(nonatomic,retain)IBOutlet UILabel *enrolledstu;
@property(nonatomic,retain)IBOutlet UIImageView*review;
@property (nonatomic) NSUInteger numberOfTabs;
@end
