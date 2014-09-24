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
    //     NSLog(@"path %@",filepath);
    //    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
    
    //  	NSLog(@"path %@",fileURL);
    // Initialize the MPMoviePlayerController object using url
    _videoPlayer =  [[MPMoviePlayerController alloc]
                     initWithContentURL:url];
    
    // Add a notification. (It will call a "moviePlayBackDidFinish" method when _videoPlayer finish or stops the plying video)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_videoPlayer];
    // Set control style tp default
    _videoPlayer.controlStyle = MPMovieControlStyleDefault;
    
    // Set shouldAutoplay to YES
    _videoPlayer.shouldAutoplay = YES;
    
    // Add _videoPlayer's view as subview to current view.
    [self.view addSubview:_videoPlayer.view];
    
    // Set the screen to full.
    [_videoPlayer setFullscreen:YES animated:YES];
    
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    MPMoviePlayerController *videoplayer = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:videoplayer];
    
    if ([videoplayer
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [videoplayer.view removeFromSuperview];
        // remove the video player from superview.
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
