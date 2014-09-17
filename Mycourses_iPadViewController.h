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
@interface Mycourses_iPadViewController : UIViewController<MBProgressHUDDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

{
    NSArray *courselist;
    NSArray *courseImages;
}
@end
