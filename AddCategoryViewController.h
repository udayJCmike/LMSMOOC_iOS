//
//  AddCategoryViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 27/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "lmsmoocAppDelegate.h"
#import "databaseurl.h"
#import "SBJSON.h"
#import "UIButton+Bootstrap.h"

@interface AddCategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
     MBProgressHUD *HUD;
    NSMutableArray *selectedlist;
    UIImage *selectedimage,*unselectedimage;
}
@property (retain, nonatomic) IBOutlet UITableView *category_tableView;
@property(retain,nonatomic)NSMutableArray *categorylist;
@end
