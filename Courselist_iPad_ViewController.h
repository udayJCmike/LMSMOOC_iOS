//
//  Courselist_iPad_ViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCellContent.h"
#import "REFrostedViewController.h"
#import "CollectionCellContent.h"
#import "REFrostedViewController.h"
#import "REFrostedViewController.h"
#import "MBProgressHUD.h"
#import "lmsmoocAppDelegate.h"
#import "databaseurl.h"
#import "SBJSON.h"
#import "UIButton+Bootstrap.h"
#import "categorypopoverViewController.h"
@interface Courselist_iPad_ViewController : UIViewController<MBProgressHUDDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIPopoverControllerDelegate>
{
    UIPopoverController*userDataPopover;
    NSString *categoryname;
    NSMutableArray*courselist;
    NSMutableArray*freecourselist;
    NSMutableArray*paidlist;
    MBProgressHUD *HUD;
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
    int offset,offset_free,offset_paid;
    NSString *course_type_val;
    
}
@property (retain, nonatomic)  UISegmentedControl *course_type;

@property (retain, nonatomic)  NSOperationQueue *imageOperationQueue;
@property (retain, nonatomic)    NSCache *imageCache;

@property(nonatomic,retain)IBOutlet UICollectionView *ipadcollection;@end
