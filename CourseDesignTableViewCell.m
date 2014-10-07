//
//  CourseDesignTableViewCell.m
//  LMSMOOC
//
//  Created by DeemsysInc on 13/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "CourseDesignTableViewCell.h"

@implementation CourseDesignTableViewCell
@synthesize coursename;
@synthesize cover;
@synthesize authorname;
@synthesize price;
@synthesize review;
@synthesize promoimage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
