//
//  AboutPageViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 06/10/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "lmsmoocAppDelegate.h"
@interface AboutPageViewController : UIViewController
{
    lmsmoocAppDelegate *delegate;
}
@property (retain, nonatomic) IBOutlet UIWebView *privacypolicy;
@property (retain, nonatomic) IBOutlet UILabel *privacylabel;

@end
