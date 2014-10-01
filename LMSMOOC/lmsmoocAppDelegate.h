//
//  lmsmoocAppDelegate.h
//  LMSMOOC
//
//  Created by DeemsysInc on 9/9/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lmsmoocAppDelegate : UIResponder <UIApplicationDelegate>
@property(strong,nonatomic)NSMutableDictionary *lectureDetail;
@property(strong,nonatomic)NSString *course_image_url;
@property(strong,nonatomic)NSString *course_detail_url;
@property(strong,nonatomic)NSString *common_url;
@property(strong,nonatomic)NSMutableDictionary *CourseDetail;
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)NSString *avatharURL;
@property(strong,nonatomic)NSString *av_image;
@property(strong,nonatomic)UIImage *profileimage;
@property(strong,nonatomic)NSMutableDictionary *Profiledetails;
-(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data))completionHandler;
@end
