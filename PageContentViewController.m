//
//  PageContentViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 09/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "PageContentViewController.h"
#import "UIButton+Bootstrap.h"
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_35 (SCREEN_HEIGHT == 480)
#define SCREEN_40 (SCREEN_HEIGHT == 568)
@interface PageContentViewController ()

@end

@implementation PageContentViewController
@synthesize imageview;
@synthesize labelcontent;
@synthesize imagebottom;
@synthesize toplogin;
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
    
    //Button Styles
    
    [self.login primaryStyle];
    [self.signup primaryStyle];
    //[self.successButton successStyle];
    //[self.infoButton infoStyle];
    //[self.warningButton warningStyle];
    //[self.dangerButton dangerStyle];
    
    //[self.bookmarkButton primaryStyle];
    //[self.bookmarkButton addAwesomeIcon:FAIconBookmark beforeTitle:YES];
    
    //[self.doneButton successStyle];
    //[self.doneButton addAwesomeIcon:FAIconCheck beforeTitle:NO];
    
    //[self.deleteButton dangerStyle];
    //[self.deleteButton addAwesomeIcon:FAIconRemove beforeTitle:YES];
    
   //[self.downloadButton defaultStyle];
    //[self.downloadButton addAwesomeIcon:FAIconDownloadAlt beforeTitle:NO];
    
    //[self.calendarButton infoStyle];
    //[self.calendarButton addAwesomeIcon:FAIconCalendar beforeTitle:NO];
    
    //[self.favoriteButton warningStyle];
    //[self.favoriteButton addAwesomeIcon:FAIconStar beforeTitle:NO];
    if (SCREEN_35) {
        for (NSLayoutConstraint *con in self.view.constraints)
        {
            if (con.firstItem == imageview && con.firstAttribute == NSLayoutAttributeBottom) {
                imagebottom.constant = 35;
            }
            if (con.firstItem == _login && con.firstAttribute == NSLayoutAttributeTop) {
               con.constant = 350;
            }
            if (con.firstItem == _signup && con.firstAttribute == NSLayoutAttributeTop) {
                con.constant = 400;
            }
        }

    }
    
    self.imageview.image = [UIImage imageNamed:self.imageFile];
   // self.imageview.contentMode = UIViewContentModeScaleAspectFill;
    
    self.labelcontent.text = self.titleText;
    _login.hidden=YES;
    _signup.hidden=YES;
    if (_pageIndex==4) {
        _login.hidden=NO;
        _signup.hidden=NO;
    }
    
    
}
- (IBAction)login:(id)sender {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(login_listener)
                                                 name:@"LoginComplete"
                                               object:nil];
    UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        loginVC.modalTransitionStyle=UIModalTransitionStyleCoverVertical;

    }
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        loginVC.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;

    }
    [self presentViewController:loginVC animated:YES completion:nil];
   
}

- (IBAction)signup:(id)sender {
    
    UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];
    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        loginVC.modalTransitionStyle=UIModalTransitionStyleCoverVertical;

    }
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        loginVC.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;

    }
  
    
    [self presentViewController:loginVC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)login_listener
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"Dashboard_iPad" bundle:nil];
        UIViewController *initialvc=[welcome instantiateInitialViewController];
        [self.navigationController pushViewController:initialvc animated:YES];
        //    initialvc.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        //    [self presentModalViewController:initialvc animated:YES];
           [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoginComplete" object:nil];
    }
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        
        UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"Dashboard_iPhone" bundle:nil];
        UIViewController *initialvc=[welcome instantiateInitialViewController];
        [self.navigationController pushViewController:initialvc animated:NO];
        //    initialvc.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        //    [self presentModalViewController:initialvc animated:YES];
           [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoginComplete" object:nil];
    }
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

- (void)dealloc {
 
    [super dealloc];
}
@end
