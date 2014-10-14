//
//  DashboardMainViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
@interface DashboardMainViewController : UINavigationController<UIGestureRecognizerDelegate>
- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender;
-(void)perform:(NSString*)name;
@end
