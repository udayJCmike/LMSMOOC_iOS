//
//  BillingDetailViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 18/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "BillingDetailViewController.h"
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_35 (SCREEN_HEIGHT == 480)
#define SCREEN_40 (SCREEN_HEIGHT == 568)
@interface BillingDetailViewController ()

@end

@implementation BillingDetailViewController
@synthesize authorname;
@synthesize coursename;
@synthesize dateofpurchase;
@synthesize price;
@synthesize promo;
@synthesize reduction;
@synthesize amountpaid;
@synthesize transactiondate;
@synthesize transactionid;
@synthesize billdatas;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SCREEN_35) {
//        for (NSLayoutConstraint *con in self.view.constraints)
//        {
//            if (con.firstItem == tableView && con.firstAttribute == NSLayoutAttributeTop) {
//                con.constant = 98;
//                self.tableheightConstraint.constant = 480;
//                [self.tableView needsUpdateConstraints];
//                
//                
//            }
//        }
    }
    coursename.text=[billdatas valueForKey:@"course_name"];
       authorname.text=[billdatas valueForKey:@"course_author"];
       dateofpurchase.text=[billdatas valueForKey:@"purchased_date"];
       price.text=[NSString stringWithFormat:@"$%@",[billdatas valueForKey:@"amount_paid"]];
    if ([[billdatas valueForKey:@"promocode"]isEqualToString:@"1"]) {
        promo.text=@"Yes";
    }
    else if([[billdatas valueForKey:@"promocode"]isEqualToString:@"0"])
    {
        promo.text=@"No";
    }
    
      // promo.text=[billdatas valueForKey:@"promocode"];
       reduction.text=[NSString stringWithFormat:@"$%@",[billdatas valueForKey:@"reduction"]];
       amountpaid.text=[NSString stringWithFormat:@"$%@",[billdatas valueForKey:@"amount_paid"]];
       transactiondate.text=[billdatas valueForKey:@"transaction_date"];
       transactionid.text=[billdatas valueForKey:@"transaction_id"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
