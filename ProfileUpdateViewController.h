//
//  ProfileUpdateViewController.h
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "MBProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>//to get URL of saved photo
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/UTCoreTypes.h>
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_35 (SCREEN_HEIGHT == 480)
#define SCREEN_40 (SCREEN_HEIGHT == 568)
@interface ProfileUpdateViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate>
{
    MBProgressHUD *HUD;
    NSString *genderval,*interestedval;
    NSString *imagename;
    BOOL isMyCtView;
    BOOL uploaded;
    UIPopoverController *popovercontroller;
     UIToolbar *toolbar;
    
    
}
@property (nonatomic, retain) UIPopoverController *popovercontroller;
@property (strong, nonatomic) IBOutlet UITextField *fname;
@property (strong, nonatomic) IBOutlet UITextField *lname;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (retain, nonatomic) IBOutlet UISegmentedControl *interestedin;
@property (retain, nonatomic) IBOutlet UISegmentedControl *gender;
@property (retain, nonatomic) IBOutlet UIButton *saveprofile;
@property (retain, nonatomic) IBOutlet UIButton *browse;
@property (retain, nonatomic) IBOutlet UIButton *upload;
@property(retain,nonatomic)IBOutlet UILabel *urllabel;
@property (retain, nonatomic) IBOutlet UIView *bg;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollview;
@property (retain, nonatomic)  NSOperationQueue *imageOperationQueue;
@property (retain, nonatomic)    NSCache *imageCache;
@end
