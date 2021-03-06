//
//  VideoPlayerViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 24/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "VideoPlayerViewController.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController
@synthesize videoname;
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
    du=[[databaseurl alloc]init];
    delegate=AppDelegate;
   // NSLog(@"value received %@",delegate.lectureDetail);
    // Do any additional setup after loading the view.
  
       [self loadDatas];
     self.navigationItem.title=@"Video Lecture";
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
             
        
       
        [self gettextList];
        
        
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
    
    
   
    
    [self performSelector:@selector(playVideo:) withObject:self afterDelay:0.2f];
        
    
    
   
    
    
    
}
-(IBAction) playVideo:(id)sender
{
    NSString*courseid= [delegate.lectureDetail objectForKey:@"id_course"];
    NSString*secid= [delegate.lectureDetail objectForKey:@"id_section"];
    NSString*lecid= [delegate.lectureDetail objectForKey:@"id_lecture"];
    videoname= [delegate.lectureDetail objectForKey:@"lecture_video"];
    NSLog(@"video name %@",videoname);
    NSString *imageUrlString = [[NSString alloc]initWithFormat:@"%@/%@/%@/%@/%@",delegate.course_image_url,courseid,secid,lecid,videoname];
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
   
//    NSString *path = @"http://techslides.com/demos/sample-videos/small.mp4";
    
    NSURL *url = [NSURL URLWithString:imageUrlString];
    //   NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"brock entrance" ofType:@"mp4"];
    //    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
    
  
    MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:url] ;
    
    // Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:playerVC
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:playerVC.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:playerVC.moviePlayer];
    
    // Set the modal transition style of your choice
  //  playerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    // Present the movie player view controller
    [self presentViewController:playerVC animated:YES completion:nil];
    
    // Start playback
    // [playerVC.moviePlayer prepareToPlay];
    // [playerVC.moviePlayer play];
    
    
    
}
- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        // Dismiss the view controller
        [self dismissMoviePlayerViewControllerAnimated];
        [self.navigationController popViewControllerAnimated:YES];
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
