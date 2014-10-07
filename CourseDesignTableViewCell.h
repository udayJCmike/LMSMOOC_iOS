//
//  CourseDesignTableViewCell.h
//  LMSMOOC
//
//  Created by DeemsysInc on 13/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDesignTableViewCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *coursename;
@property(nonatomic,strong)IBOutlet UILabel *authorname;
@property(nonatomic,strong)IBOutlet UILabel *price;
@property(nonatomic,strong)IBOutlet UIImageView *review;
@property(nonatomic,strong)IBOutlet UIImageView *cover;
@property(nonatomic,strong)IBOutlet UIImageView *promoimage;
@end
