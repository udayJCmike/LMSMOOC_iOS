//
//  AboutPageViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 06/10/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "AboutPageViewController.h"
#import <QuartzCore/QuartzCore.h>
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface AboutPageViewController ()
{
    NSString *privacyurl;
}
@end

@implementation AboutPageViewController
@synthesize privacylabel;
@synthesize privacypolicy;
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
    [privacylabel.layer setCornerRadius:6];
    delegate=AppDelegate;
    privacyurl=[NSString stringWithFormat:@"%@user_view_PrivacyPolicy",delegate.common_url];
   // NSLog(@"privacy url %@",privacyurl);
    // Do any additional setup after loading the view.
    if (self.navigationController.navigationBar.hidden == YES)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(menulistener:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menulistener:)
                                                 name:@"Showmenu"
                                               object:nil];
   // [privacypolicy loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc]initWithString:privacyurl]]];
}
    - (void)menulistener:(id)sender {
        
        
        
        [self.view endEditing:YES];
        [self.frostedViewController.view endEditing:YES];
        [self.frostedViewController presentMenuViewController];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Showmenu" object:nil];
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

- (void)dealloc {
 
    [super dealloc];
}
@end
