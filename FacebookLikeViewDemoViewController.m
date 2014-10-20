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
@property (retain, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation FacebookLikeViewDemoViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.facebook = [[Facebook alloc] initWithAppId:@"775632699174713" andDelegate:self];
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
    
    self.facebookLikeView.href = [NSURL URLWithString:@"https://www.facebook.com/pages/Learnterest-Best-Online-Learning-Marketplace/280656465457314"];
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
    //    NSString *twitterFollowButton = @"<a href='https://twitter.com/Udayjcdev' class='twitter-follow-button' data-show-count='false' data-size='large'>Follow @Udayjcdev</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>";
    //
    //
    //
    //    [self.webview loadHTMLString:twitterFollowButton baseURL:nil];
    NSString *tem = self.terms.titleLabel.text;
    
    if (tem != nil && ![tem isEqualToString:@""]) {
        NSMutableAttributedString *temString=[[NSMutableAttributedString alloc]initWithString:tem];
        [temString addAttribute:NSUnderlineStyleAttributeName
                          value:[NSNumber numberWithInt:1]
                          range:(NSRange){0,[temString length]}];
        
        self.terms.titleLabel.attributedText = temString;
    }
    NSString *pri = self.privacy.titleLabel.text;
    
    if (pri != nil && ![pri isEqualToString:@""]) {
        NSMutableAttributedString *temString=[[NSMutableAttributedString alloc]initWithString:pri];
        [temString addAttribute:NSUnderlineStyleAttributeName
                          value:[NSNumber numberWithInt:1]
                          range:(NSRange){0,[temString length]}];
        
        self.privacy.titleLabel.attributedText = temString;
    }
    NSString *why = self.whylearnterest.titleLabel.text;
    
    if (why != nil && ![why isEqualToString:@""]) {
        NSMutableAttributedString *temString=[[NSMutableAttributedString alloc]initWithString:why];
        [temString addAttribute:NSUnderlineStyleAttributeName
                          value:[NSNumber numberWithInt:1]
                          range:(NSRange){0,[temString length]}];
        
        self.whylearnterest.titleLabel.attributedText = temString;
    }
    
}
- (void)menulistener:(id)sender {
    
    
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Showmenu" object:nil];
}
-(IBAction)FollowUsOnTwitter:(id)sender {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
    [self performSelector:@selector(postontwitter) withObject:self afterDelay:0.2f];
    
    
    
    
}
-(void)postontwitter
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            //            NSLog(@"account array %@",accountsArray);41077
            // here, I'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present. see Note section below if there are multiple accounts
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setValue:@"Learnterest" forKey:@"screen_name"];
                [tempDict setValue:@"true" forKey:@"follow"];
                TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"]  parameters:tempDict requestMethod:TWRequestMethodPOST];
                [postRequest setAccount:twitterAccount];
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
                    NSLog(@"%@", output);
                    if ([urlResponse statusCode] == 200) {
                        [HUD hide:YES];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Follow us successfull!" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alert show];
                        
                    }
                    else {
                        [HUD hide:YES];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Follow us Failed!" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                }];
            }
            else
            {
                if (![TWTweetComposeViewController canSendTweet]) {
                    [HUD hide:YES];
                    UIAlertView *alertViewTwitter = [[[UIAlertView alloc]
                                                      initWithTitle:@"No Twitter Accounts"
                                                      message:@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings."
                                                      delegate:self
                                                      cancelButtonTitle:@"Ok"
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
- (IBAction)termsofuse:(id)sender {
    
    if (self.navigationController.navigationBar.hidden == NO)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
//    [MTPopupWindow showWindowWithHTMLFile:@"http://208.109.248.89:8087/OnlineCourse/user_view_Termsofuses" insideView:self.view];
    MTPopupWindow *popup = [[MTPopupWindow alloc] init];
    popup.usesSafari = YES;
    popup.fileName = @"http://208.109.248.89:8087/OnlineCourse/user_view_Termsofuses";
    popup.delegate=self;
    [popup show];
   
    
}
- (IBAction)privacy:(id)sender {
    if (self.navigationController.navigationBar.hidden == NO)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    MTPopupWindow *popup = [[MTPopupWindow alloc] init];
    popup.usesSafari = YES;
    popup.fileName = @"http://208.109.248.89:8087/OnlineCourse/user_view_PrivacyPolicy";
    popup.delegate=self;
    [popup show];
 //   [MTPopupWindow showWindowWithHTMLFile:@"http://208.109.248.89:8087/OnlineCourse/user_view_PrivacyPolicy" insideView:self.view];
}
- (IBAction)whylearnterest:(id)sender {
    if (self.navigationController.navigationBar.hidden == NO)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    MTPopupWindow *popup = [[MTPopupWindow alloc] init];
    popup.usesSafari = YES;
    popup.fileName = @"http://208.109.248.89:8087/OnlineCourse/whylearnterest";
    popup.delegate=self;
    [popup show];
  // [MTPopupWindow showWindowWithHTMLFile:@"http://208.109.248.89:8087/OnlineCourse/whylearnterest" insideView:self.view];
}
-(void)willCloseMTPopupWindow:(MTPopupWindow *)sender
{

    if (self.navigationController.navigationBar.hidden == YES)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.facebookLikeView = nil;
}

- (void)dealloc {
    [_webview release];
    [_terms release];
    [super dealloc];
}
@end
