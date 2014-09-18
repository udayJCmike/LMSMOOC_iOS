//
//  BillingTableViewCell.h
//  LMSMOOC
//
//  Created by DeemsysInc on 18/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillingTableViewCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UILabel *coursename;
@property(nonatomic,retain)IBOutlet UILabel *purchaseddate;
@property(nonatomic,retain)IBOutlet UILabel *promocode;
@property(nonatomic,retain)IBOutlet UILabel *reduction;
@property(nonatomic,retain)IBOutlet UILabel *amount;
@end
