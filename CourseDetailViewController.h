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
#import "RDActivityViewController.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface CourseDetailViewController : ViewPagerController<ViewPagerDataSource, ViewPagerDelegate,MBProgressHUDDelegate,UIActivityItemSource,RDActivityViewControllerDelegate>
{
    lmsmoocAppDelegate *delegate;
    MBProgressHUD *HUD;
   
}
@property(nonatomic,retain)NSDictionary *SelectedCourse;
@property(nonatomic,retain)IBOutlet UILabel *coursename;
@property(nonatomic,retain)IBOutlet UILabel *enrolledstu;
@property(nonatomic,retain)IBOutlet UIImageView*review;
@property (retain, nonatomic) IBOutlet UILabel *price;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *sharebutton;
@property (nonatomic) NSUInteger numberOfTabs;
@end
