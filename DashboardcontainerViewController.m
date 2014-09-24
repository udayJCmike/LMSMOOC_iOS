//
//  DashboardcontainerViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "DashboardcontainerViewController.h"

#import "databaseurl.h"

@interface DashboardcontainerViewController ()
{
    databaseurl *du;
}
@end

@implementation DashboardcontainerViewController

- (void)awakeFromNib
{
    UIStoryboard *welcome;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
         welcome=[UIStoryboard storyboardWithName:@"Dashboard_iPad" bundle:nil];
    }
    else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        welcome=[UIStoryboard storyboardWithName:@"Dashboard_iPhone" bundle:nil];
    }
  
    self.contentViewController = [welcome instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [welcome instantiateViewControllerWithIdentifier:@"menuController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    du=[[databaseurl alloc]init];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(menu:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self menu:nil];
   
}
- (void)menu:(id)sender {
    if (self.navigationController.navigationBar.hidden == NO)
    {
        // hide the Navigation Bar
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Showmenu"
                                                        object:self
                                                      userInfo:nil];
   
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

@end
