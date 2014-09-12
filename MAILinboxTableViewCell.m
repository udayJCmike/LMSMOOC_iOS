//
//  MAILinboxTableViewCell.m
//  LMSMOOC
//
//  Created by DeemsysInc on 12/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "MAILinboxTableViewCell.h"

@implementation MAILinboxTableViewCell
@synthesize Subject;
@synthesize date;
@synthesize importantstatus;
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

- (void)dealloc {
   
    [super dealloc];
}
@end
