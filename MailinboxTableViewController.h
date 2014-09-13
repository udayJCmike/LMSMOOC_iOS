//
//  MailinboxTableViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "MBProgressHUD.h"
#import "databaseurl.h"
#import "SBJSON.h"
#import "MAILinboxTableViewCell.h"
#import "MailDetailsViewController.h"
@interface MailinboxTableViewController : UITableViewController<MBProgressHUDDelegate>
{
   __block  NSMutableArray *inbox;
    MBProgressHUD *HUD;
    
    
}
@end
