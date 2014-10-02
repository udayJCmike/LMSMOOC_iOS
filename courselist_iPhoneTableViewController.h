//
//  courselist_iPhoneTableViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "MBProgressHUD.h"
#import "lmsmoocAppDelegate.h"
#import "databaseurl.h"
#import "SBJSON.h"
#import "CourseDesignTableViewCell.h"
#import "UIButton+Bootstrap.h"
#import "CategorywiseDatasViewController.h"
@interface courselist_iPhoneTableViewController : UIViewController<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView* footerView;
    NSMutableArray*courselist;
     NSMutableArray*freecourselist;
     NSMutableArray*paidlist;
     MBProgressHUD *HUD;
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
    int offset,offset_free,offset_paid;
    NSString *course_type_val;
    
}
@property (retain, nonatomic) IBOutlet UISegmentedControl *course_type;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic)  NSOperationQueue *imageOperationQueue;
@property (retain, nonatomic)    NSCache *imageCache;
@property (retain, nonatomic) IBOutlet UITableView *category_tableView;
@property(retain,nonatomic)NSMutableArray *categorylist;
@property(retain,nonatomic)IBOutlet NSLayoutConstraint *tableheightConstraint;
@property(retain,nonatomic)IBOutlet NSLayoutConstraint *categorytableheightConstraint;
@end
