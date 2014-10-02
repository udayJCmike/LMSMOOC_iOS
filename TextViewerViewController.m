//
//  TextViewerViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 24/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "TextViewerViewController.h"

@interface TextViewerViewController ()

@end

@implementation TextViewerViewController
@synthesize webView;
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
    [super viewDidLoad]; if (SCREEN_35) {
        for (NSLayoutConstraint *con in self.view.constraints)
        {
            if (con.firstItem == self.webView && con.firstAttribute == NSLayoutAttributeTop) {
                
                self.webviewheight.constant = 500;
                [self.webView needsUpdateConstraints];
                
                
            }
        }
    }
    du=[[databaseurl alloc]init];
    delegate=AppDelegate;
 //  NSLog(@"value received %@",delegate.lectureDetail);
    // Do any additional setup after loading the view.
   
    [self loadDatas];
     self.navigationItem.title=@"Text Lecture";
}
-(void)loadDatas
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
    if ([[du submitvalues]isEqualToString:@"Success"])
    {
      
        
        
        [self performSelector:@selector(gettextList) withObject:self afterDelay:0.2f];
        
        
        
    }
    else
    {
        //[HUD hide:YES];
        HUD.labelText = @"Check network connection";
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        HUD.mode = MBProgressHUDModeCustomView;
        [HUD hide:YES afterDelay:1];
    }
    
}
-(void)gettextList
{
    
    NSString*courseid= [delegate.lectureDetail objectForKey:@"id_course"];
    NSString*secid= [delegate.lectureDetail objectForKey:@"id_section"];
    NSString*lecid= [delegate.lectureDetail objectForKey:@"id_lecture"];
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"LectureDetails.php";
    
    NSString *URLString=[NSString stringWithFormat:@"%@%@?courseid=%@&sectionid=%@&lectureid=%@",urltemp,url1,courseid,secid,lecid];
    
//    NSString *search = [du MultipleCharactersHTML:URLString];
//    
//   
//    
//    [webView loadHTMLString:search baseURL:nil];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];

    
        if (![HUD isHidden]) {
        [HUD hide:YES];
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
