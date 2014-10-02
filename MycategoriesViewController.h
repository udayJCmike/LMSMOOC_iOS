//
//  MycategoriesViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 18/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "MBProgressHUD.h"
#import "lmsmoocAppDelegate.h"
#import "databaseurl.h"
#import "SBJSON.h"
#import "UIButton+Bootstrap.h"
#import "MycategoriesDetailViewController.h"


@interface MycategoriesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    int loadcompleted;
    NSString *studentid;
    NSMutableArray *mycategories;
    IBOutlet UIBarButtonItem *categorybutton;
}
@property (retain, nonatomic) IBOutlet UITableView *category_tableView;
@property(retain,nonatomic)NSMutableArray *categorylist;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *tableheightConstraint;



@end
