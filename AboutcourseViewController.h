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
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface AboutcourseViewController : UIViewController
{
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
}
@property(nonatomic,retain)IBOutlet UITextView *course_des;
@end
