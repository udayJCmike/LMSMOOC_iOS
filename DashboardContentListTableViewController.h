//
//  DashboardContentListTableViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillingTableViewController.h"
#import "MyauthorsTableViewController.h"
#import "MycategoriesTableViewController.h"
#import "MyfavoritesTableViewController.h"
#import "MycoursesTableViewController.h"
#import "MailinboxTableViewController.h"
#import "courselist_iPhoneTableViewController.h"
#import "DashboardMainViewController.h"
#import "DashboardcontainerViewController.h"
#import "ProfileUpdateViewController.h"
@interface DashboardContentListTableViewController : UITableViewController
{
    UIImage *profileimage;
}
-(void)reloadTableContent;
@end
