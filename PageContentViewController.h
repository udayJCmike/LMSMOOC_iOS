//
//  PageContentViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 09/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UILabel *labelcontent;
@property (strong, nonatomic) IBOutlet UIButton *login;
@property (strong, nonatomic) IBOutlet UIButton *signup;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *imagebottom;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *toplogin;
@end
