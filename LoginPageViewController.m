//
//  LoginPageViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 09/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "LoginPageViewController.h"

@interface LoginPageViewController ()

@end

@implementation LoginPageViewController
@synthesize username;
@synthesize password;
@synthesize reminder;
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
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *get=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:get];
  
}
-(void)dismissKeyboard
{
    [username resignFirstResponder];
    
    [password resignFirstResponder];
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)forgotpassword:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://208.109.248.89:8085/OnlineCourse/Student/signup" ]];
}
- (IBAction)login:(id)sender
{
    
}
- (IBAction)checkbox:(UIButton*)sender {
    
    sender.selected = !sender.selected;
    if(sender.selected){
        [sender setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
    }
    else{
        [sender setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    }
    
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
