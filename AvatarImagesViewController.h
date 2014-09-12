//
//  AvatarImagesViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 11/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "databaseurl.h"
#import "lmsmoocAppDelegate.h"
@interface AvatarImagesViewController : UICollectionViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
    NSMutableArray *avatarimages;
     NSMutableArray *imageURL;
    __block NSMutableArray *imagedata;
    
    
}
@property(nonatomic,strong)NSString *gendervalue;
@property dispatch_group_t imageQueue;
@end
