//
//  AddCategoriesTableViewCell.m
//  LMSMOOC
//
//  Created by DeemsysInc on 27/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "AddCategoriesTableViewCell.h"

@implementation AddCategoriesTableViewCell
@synthesize marked;
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
