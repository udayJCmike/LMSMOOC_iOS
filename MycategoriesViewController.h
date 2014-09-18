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


@interface MycategoriesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    int loadcompleted;
    NSString *studentid;
    NSMutableArray *mycategories;
}
@property (retain, nonatomic) IBOutlet UITableView *category_tableView;
@property(retain,nonatomic)NSMutableArray *categorylist;




@end
