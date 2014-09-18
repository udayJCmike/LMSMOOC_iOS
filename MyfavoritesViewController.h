//
//  MyfavoritesViewController.h
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
#import "CourseDesignTableViewCell.h"
@interface MyfavoritesViewController : UIViewController <MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray*courselist;
    MBProgressHUD *HUD;
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
    int offset;
}
@property(nonatomic,retain)NSString *studentid;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic)  NSOperationQueue *imageOperationQueue;
@property (retain, nonatomic)    NSCache *imageCache;



@end
