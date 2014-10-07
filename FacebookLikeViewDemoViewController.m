//
//  LikeButtonDemoViewController.m
//  LikeButtonDemo
//
//  Created by Tom Brow on 6/27/11.
//  Copyright 2011 Yardsellr. All rights reserved.
//

#import "FacebookLikeViewDemoViewController.h"
#import "FBConnect.h"
#import "FacebookLikeView.h"


@interface FacebookLikeViewDemoViewController () <FacebookLikeViewDelegate, FBSessionDelegate>

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) IBOutlet FacebookLikeView *facebookLikeView;

@end

@implementation FacebookLikeViewDemoViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.facebook = [[Facebook alloc] initWithAppId:@"839464456086590" andDelegate:self];
    }
    return self;
}


#pragma mark FBSessionDelegate

- (void)fbDidLogin {
	self.facebookLikeView.alpha = 1;
    [self.facebookLikeView load];
}

- (void)fbDidLogout {
	self.facebookLikeView.alpha = 1;
    [self.facebookLikeView load];
}

#pragma mark FacebookLikeViewDelegate

- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView {
    [self.facebook authorize:[NSArray array]];
}

- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
    self.facebookLikeView.alpha = 1;
    [UIView commitAnimations];
}

- (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liked"
                                                     message:@"You liked learnterest. Thanks!"
                                                    delegate:self 
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
    [alert show];
}

- (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unliked"
                                                     message:@"You unliked learnterest. Where's the love?"
                                                    delegate:self 
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
    [alert show];
}

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.facebookLikeView.href = [NSURL URLWithString:@"https://www.facebook.com/AmitabhBachchan"];
    self.facebookLikeView.layout = @"button_count";
    self.facebookLikeView.showFaces = NO;
    self.facebookLikeView.alpha = 0;
    [self.facebookLikeView load];
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
  

}
- (void)menulistener:(id)sender {
    
    
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Showmenu" object:nil];
}
-(IBAction)FollowUsOnTwitter:(id)sender {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
//            NSLog(@"account array %@",accountsArray);
            // here, I'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present. see Note section below if there are multiple accounts
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setValue:@"deemsys" forKey:@"screen_name"];
                [tempDict setValue:@"true" forKey:@"follow"];
                TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"]  parameters:tempDict requestMethod:TWRequestMethodPOST];
                [postRequest setAccount:twitterAccount];
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
                    NSLog(@"%@", output);
                    if ([urlResponse statusCode] == 200) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Follow us successfull" message:nil delegate:nil cancelButtonTitle:@"Thanx" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Follow us Failed" message:nil delegate:nil cancelButtonTitle:@"Thanx" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                }];
            }
            else
            {
                if (![TWTweetComposeViewController canSendTweet]) {
                    UIAlertView *alertViewTwitter = [[[UIAlertView alloc]
                                                      initWithTitle:@"No Twitter Accounts"
                                                      message:@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings."
                                                      delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:nil] autorelease];
                    
                    [alertViewTwitter show];
                }
            }
            
        }
    }];


     
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    if (buttonIndex==0) {
//        TWTweetComposeViewController *ctrl = [[TWTweetComposeViewController alloc] init];
//        if ([ctrl respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
//        {
//         //FOR iOS 8
//            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]])
//            {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://"]];
//            }
//        }
//        [ctrl release];
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.facebookLikeView = nil;
}

@end
