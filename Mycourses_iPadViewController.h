//
//  Mycourses_iPadViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCellContent.h"
#import "REFrostedViewController.h"
#import "MBProgressHUD.h"
#import "lmsmoocAppDelegate.h"
#import "databaseurl.h"
#import "SBJSON.h"
#import "UIButton+Bootstrap.h"
@interface Mycourses_iPadViewController : UIViewController<MBProgressHUDDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

{
    NSMutableArray*courselist;
    MBProgressHUD *HUD;
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
    int offset;
}

@property (retain, nonatomic) IBOutlet UICollectionView *ipadcollection;
@property (retain, nonatomic)  NSOperationQueue *imageOperationQueue;
@property (retain, nonatomic)    NSCache *imageCache;

@end
