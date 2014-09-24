//
//  SyllabusViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 22/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lmsmoocAppDelegate.h"
#import "MBProgressHUD.h"
#import "databaseurl.h"
#import "SyllabusLectureTableViewCell.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface SyllabusViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
    NSMutableArray      *sectionTitleArray;
    NSMutableDictionary *sectionContentDict;
    NSMutableArray      *arrayForBool;
    NSMutableDictionary *syllabus_details;
   
}
@property (retain, nonatomic) IBOutlet UITableView *SyllabustableView;

@end
