//
//  CategorywiseDatasViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 16/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "lmsmoocAppDelegate.h"
#import "databaseurl.h"
#import "CourseDesignTableViewCell.h"
@interface CategorywiseDatasViewController : UIViewController<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
{
     NSMutableArray*courselist;
    MBProgressHUD *HUD;
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
    int offset;
}
@property(nonatomic,retain)NSString *categoryname;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic)  NSOperationQueue *imageOperationQueue;
@property (retain, nonatomic)    NSCache *imageCache;



@end
