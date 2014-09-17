//
//  CollectionCellContent.h
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCellContent : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UILabel *coursename;
@property (retain, nonatomic) IBOutlet UILabel *authorname;
@property (retain, nonatomic) IBOutlet UILabel *price;
@property (retain, nonatomic) IBOutlet UIImageView *cover;
@property (retain, nonatomic) IBOutlet UIImageView *review;

@end
