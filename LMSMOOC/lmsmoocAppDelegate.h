//
//  lmsmoocAppDelegate.h
//  LMSMOOC
//
//  Created by DeemsysInc on 9/9/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lmsmoocAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)NSString *avatharURL;
@property(strong,nonatomic)UIImage *av_image;

@property(strong,nonatomic)NSMutableDictionary *Profiledetails;

@end
