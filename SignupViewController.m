//
//  SignupViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 09/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController
@synthesize fname;
@synthesize lname;
@synthesize username;
@synthesize email;
@synthesize password;
@synthesize cpassword;
@synthesize terms;
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
    UITapGestureRecognizer *get=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:get];
    // Do any additional setup after loading the view.
}
-(void)dismissKeyboard
{
    [fname resignFirstResponder];
    [lname resignFirstResponder];
    [username resignFirstResponder];
    [email resignFirstResponder];
    [cpassword resignFirstResponder];
    [password resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)termsOfservice:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://208.109.248.89:8085/OnlineCourse/user_view_Termsofuses" ]];
}
- (IBAction)signup:(id)sender {
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
