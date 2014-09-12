//
//  PageContentViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 09/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController
@synthesize imageview;
@synthesize labelcontent;
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
    self.imageview.image = [UIImage imageNamed:self.imageFile];
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

@end
