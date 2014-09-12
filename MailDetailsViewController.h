//
//  MailDetailsViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 12/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "databaseurl.h"
#import "SBJSON.h"
@interface MailDetailsViewController : UIViewController<MBProgressHUDDelegate>
{
    MBProgressHUD*HUD;
    databaseurl *du;
    NSString *imp;
}
@property (retain, nonatomic) IBOutlet UILabel *from;
@property (retain, nonatomic) IBOutlet UILabel *to;
@property (retain, nonatomic) IBOutlet UILabel *date;
@property (retain, nonatomic) IBOutlet UITextView *body;
@property(nonatomic,strong)NSMutableDictionary*selectedrow;
@property (retain, nonatomic) IBOutlet UIButton *important;
@end
