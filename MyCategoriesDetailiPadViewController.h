//
//  MyCategoriesDetailiPadViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 19/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCellContent.h"
#import "MBProgressHUD.h"
#import "lmsmoocAppDelegate.h"
#import "databaseurl.h"
#import "SBJSON.h"
#import "UIButton+Bootstrap.h"
@interface MyCategoriesDetailiPadViewController : UIViewController<MBProgressHUDDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

{
    int loadcompleted;
    NSMutableArray*courselist;
    MBProgressHUD *HUD;
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
    int offset;
}

@property (retain, nonatomic) IBOutlet UICollectionView *ipadcollection;
@property (retain, nonatomic)  NSOperationQueue *imageOperationQueue;
@property (retain, nonatomic)    NSCache *imageCache;

@property(nonatomic,retain)NSString *categoryname;
@end
