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
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
    [self loadDatas];
}
-(void)loadDatas
{
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
    
    
    NSString*courseid= [delegate.lectureDetail objectForKey:@"id_course"];
    NSString*secid= [delegate.lectureDetail objectForKey:@"id_section"];
    NSString*lecid= [delegate.lectureDetail objectForKey:@"id_lecture"];
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"LectureDetailsAudio_Video.php";
    
    NSString *URLString=[NSString stringWithFormat:@"%@%@?courseid=%@&sectionid=%@&lectureid=%@",urltemp,url1,courseid,secid,lecid];
    
    NSMutableArray *search = [du MultipleCharacters:URLString];
    
    NSArray* menu = [search valueForKey:@"serviceresponse"];
    
    
//   NSLog(@"menu %@",menu);
    
    if ([menu count]>0)
    {
        
       // NSLog(@"%@",[menu valueForKey:@"lecture_video"]);
        videoname=[menu valueForKey:@"lecture_video"];
         [self performSelector:@selector(playVideo:) withObject:self afterDelay:5.0f];
        
    }
    else
    {
        if (![HUD isHidden]) {
            [HUD hide:YES];
        }
        
        NSLog(@"No Datas found");
    }
    //        NSLog(@"section title array %@",sectionTitleArray);
    //      NSLog(@"section content array %@",sectionContentDict);
    //         NSLog(@"section bool array %@",arrayForBool);
    
    
    
   
    
    
    
}
-(IBAction) playVideo:(id)sender
{
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    // NSString *imageUrlString = [[NSString alloc]initWithFormat:@"%@/%@/%@",delegate.course_image_url,courseid,videoname];
    NSString *path = @"http://techslides.com/demos/sample-videos/small.mp4";
    
    NSURL *url = [NSURL URLWithString:path];
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
