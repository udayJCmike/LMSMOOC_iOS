//
//  CollectionCellContent.m
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "CollectionCellContent.h"

@implementation CollectionCellContent
@synthesize coursename;
@synthesize cover;
@synthesize authorname;
@synthesize price;
@synthesize review;
@synthesize promoimage;
@synthesize enrolled;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    
    [super dealloc];
}
@end
