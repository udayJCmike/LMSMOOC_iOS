//
//  BillingDetailViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 18/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillingDetailViewController : UIViewController
@property(nonatomic,retain)NSDictionary *billdatas;
@property(nonatomic,retain)IBOutlet UILabel *coursename;
@property(nonatomic,retain)IBOutlet UILabel *authorname;
@property(nonatomic,retain)IBOutlet UILabel *dateofpurchase;
@property(nonatomic,retain)IBOutlet UILabel *price;
@property(nonatomic,retain)IBOutlet UILabel *promo;
@property(nonatomic,retain)IBOutlet UILabel *reduction;
@property(nonatomic,retain)IBOutlet UILabel *amountpaid;
@property(nonatomic,retain)IBOutlet UILabel *transactiondate;
@property(nonatomic,retain)IBOutlet UILabel *transactionid;

@end
