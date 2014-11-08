//
//  lmsmoocAppDelegate.m
//  LMSMOOC
//
//  Created by DeemsysInc on 9/9/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "lmsmoocAppDelegate.h"
#import<MediaPlayer/MediaPlayer.h>
#import "SBJSON.h"
#import "databaseurl.h"
#import "LoginPageViewController.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@implementation lmsmoocAppDelegate
{
    databaseurl *du;
    
}
@synthesize avatharURL;
@synthesize av_image;
@synthesize Profiledetails;
@synthesize profileimage;
@synthesize course_image_url;
@synthesize CourseDetail;
@synthesize lectureDetail;
@synthesize deviceid;
@synthesize tockenid;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor=[UIColor clearColor];
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    // [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    deviceid= [self getUniqueDeviceIdentifierAsString];
    [[NSUserDefaults standardUserDefaults]setValue:deviceid forKey:@"deviceid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
   
    if (([[[NSUserDefaults standardUserDefaults]valueForKey:@"username"] length]>0)&&([[[NSUserDefaults standardUserDefaults]valueForKey:@"password"] length]>0))
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            self.sessionLogin=YES;
            UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"Dashboard_iPad" bundle:nil];
            UIViewController *initialvc=[welcome instantiateInitialViewController];
            self.window.rootViewController=initialvc;
        }
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            self.sessionLogin=YES;
            UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"Dashboard_iPhone" bundle:nil];
            UIViewController *initialvc=[welcome instantiateInitialViewController];
            self.window.rootViewController=initialvc;
        }
        
        LoginPageViewController *login=[[LoginPageViewController alloc]init];
        [login checkdataForLogin];
    }
    else
    {
        self.sessionLogin=NO;
    }
    return YES;
}







- (void)applicationWillResignActive:(UIApplication *)application
{
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [self updateBadgeNumber];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        
        if ([[self.window.rootViewController presentedViewController] isKindOfClass:[MPMoviePlayerViewController class]]) {
            
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }
        else {
            
            if ([[self.window.rootViewController presentedViewController]
                 isKindOfClass:[UINavigationController class]])
            {
                
                // look for it inside UINavigationController
                UINavigationController *nc = (UINavigationController *)[self.window.rootViewController presentedViewController];
                
                // is at the top?
                if ([nc.topViewController isKindOfClass:[MPMoviePlayerViewController class]])
                {
                    
                    return UIInterfaceOrientationMaskAllButUpsideDown;
                    
                    // or it's presented from the top?
                }
                else if ([[nc.topViewController presentedViewController]isKindOfClass:[MPMoviePlayerViewController class]])
                {
                    
                    return UIInterfaceOrientationMaskAllButUpsideDown;
                }
                
                
                
                
            }
            
        }
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskLandscape;
    
    
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
    NSString *newToken = [deviceToken description];
	newToken = [newToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    newToken = [newToken stringByReplacingOccurrencesOfString:@">" withString:@""];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    tockenid=newToken;
    // NSLog(@"content---%@", newToken);
    [[NSUserDefaults standardUserDefaults]setValue:tockenid forKey:@"tockenid"];
    deviceid= [self getUniqueDeviceIdentifierAsString];
    [[NSUserDefaults standardUserDefaults]setValue:deviceid forKey:@"deviceid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (([deviceid length]>0)&&([[NSUserDefaults standardUserDefaults]valueForKey:@"tockenid"])) {
        // NSLog(@"resign activity");
        [self updateid];
    }
    
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@" Remote Notifications(%@)", userInfo);
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Learnterest"
                                                        message:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]objectForKey:@"body"]
                                                       delegate:self cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
         [self updateBadgeNumber];
        
//        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//        localNotification.fireDate = [NSDate date];
//        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//        localNotification.timeZone = [NSTimeZone defaultTimeZone];
//        
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
    }
    
    
}
-(NSString *)getUniqueDeviceIdentifierAsString
{
    
    
    
    NSString *strApplicationUUID ;
    
    strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //NSLog(@"UUID %@",strApplicationUUID);
    
    
    
    return strApplicationUUID;
}
-(void)updateid
{
    du=[[databaseurl alloc]init];
    
    dispatch_group_t imageQueue = dispatch_group_create();
    
    dispatch_group_async(imageQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                         ^{
                             NSString *response=[self HttpPostEntityFirstURL1:@"name" ForValue1:@"lms"  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
                             NSError *error;
                             
                             SBJSON *json = [[SBJSON new] autorelease];
                             NSDictionary *parsedvalue = [json objectWithString:response error:&error];
                             
                             // NSLog(@"%@ parsedvalue",response);
                             if (parsedvalue == nil)
                             {
                                 
                                 //NSLog(@"parsedvalue == nil");
                                 
                             }
                             else
                             {
                                 
                                 NSDictionary* menu = [parsedvalue objectForKey:@"serviceresponse"];
                                 
                                 if ([[menu objectForKey:@"success"] isEqualToString:@"Yes"])
                                 {
                                     NSLog(@"succesful");
                                     
                                 }
                                 else
                                 {
                                     NSLog(@"failure");
                                 }
                                 
                             }
                             
                             
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 //Your code to execute on UIthread (main thread)
                             });
                         });
}
-(void)updateBadgeNumber
{
    du=[[databaseurl alloc]init];
    
    dispatch_group_t imageQueue = dispatch_group_create();
    
    dispatch_group_async(imageQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                         ^{
                           
                             NSString *response=[self HttpPostEntityFirstURLBadge1:@"deviceid" ForValue1:[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceid"]  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
                             NSError *error;
                             
                             SBJSON *json = [[SBJSON new] autorelease];
                             NSDictionary *parsedvalue = [json objectWithString:response error:&error];
                             
                             //NSLog(@"%@ parsedvalue",response);
                             if (parsedvalue == nil)
                             {
                                 
                                 //NSLog(@"parsedvalue == nil");
                                 
                             }
                             else
                             {
                                 
                                 NSDictionary* menu = [parsedvalue objectForKey:@"serviceresponse"];
                                 
                                 if ([[menu objectForKey:@"success"] isEqualToString:@"Yes"])
                                 {
                                     NSLog(@"succesful");
                                     
                                 }
                                 else
                                 {
                                     NSLog(@"failure");
                                 }
                                 
                             }
                             
                             
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 //Your code to execute on UIthread (main thread)
                             });
                         });


}
-(NSString *)HttpPostEntityFirstURL1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Device_tocken_id.php?service=tockeninsert";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&deviceid=%@&tockenid=%@&%@=%@",firstEntity,value1,[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceid"],[[NSUserDefaults standardUserDefaults]valueForKey:@"tockenid"],secondEntity,value2];
    NSURL *url = [NSURL URLWithString:url2];
    
    return [du returndbresult:post URL:url];
}
-(NSString *)HttpPostEntityFirstURLBadge1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Device_tocken_id.php?service=Badgeupdate";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
   // NSLog(@"url %@",url2);
    
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&%@=%@",firstEntity,value1,secondEntity,value2];
    
    // NSLog(@"post %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    
    return [du returndbresult:post URL:url];
}

@end
