//
//  AudioPlayerViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 24/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "AudioPlayerViewController.h"

@interface AudioPlayerViewController ()
{
  
   
    
    
}

@end


@implementation AudioPlayerViewController
@synthesize audioname;
@synthesize toggleplaypause;
@synthesize slider;
@synthesize durationoutlet;
@synthesize totaltime;
@synthesize bg;
@synthesize player;
@synthesize playerItem;
@synthesize asset;

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
  //  NSLog(@"value received %@",delegate.lectureDetail);
    // Do any additional setup after loading the view.
    
    durationoutlet.text=@"00:00";
    totaltime.text=@"00:00";
    [self loadDatas];
    bg.layer.cornerRadius=5;
    bg.layer.masksToBounds=YES;
    self.navigationItem.title=@"Audio Lecture";
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
    
   
    audioname= [delegate.lectureDetail objectForKey:@"lecture_audio"];
   
    
    if ([audioname length]>0) {
        [self performSelector:@selector(playselectedsong) withObject:self afterDelay:0.2f];
      
        
    }
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(id)sender {
    
    if(toggleplaypause.selected) {
        [self.player pause];
        [toggleplaypause setImage:[UIImage imageNamed:@"play_button.png"] forState:UIControlStateNormal];
         [toggleplaypause setImage:[UIImage imageNamed:@"play_button.png"] forState:UIControlStateSelected];
        [self.toggleplaypause setSelected:NO];
    }
    else {
        [self.player play];
        [toggleplaypause setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        [toggleplaypause setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateSelected];
        [self.toggleplaypause setSelected:YES];
    }
    
    
}
- (IBAction)sliderDragged:(id)sender {
    [self.player seekToTime:CMTimeMakeWithSeconds((int)(self.slider.value) , 1)];
}
-(void)playselectedsong{
   
    
    NSString*courseid= [delegate.lectureDetail objectForKey:@"id_course"];
    NSString*secid= [delegate.lectureDetail objectForKey:@"id_section"];
    NSString*lecid= [delegate.lectureDetail objectForKey:@"id_lecture"];
    audioname= [delegate.lectureDetail objectForKey:@"lecture_audio"];
    NSString *imageUrlString = [[NSString alloc]initWithFormat:@"%@%@/%@/%@/%@",delegate.course_image_url,courseid,secid,lecid,audioname];
    
//    NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"dairy-milk-kiss-me-file" ofType:@"mp3"];
//    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
   // NSLog(@"audio url %@",filepath);
    NSURL *url = [NSURL URLWithString:imageUrlString];
    //http://tamilmp3hub.com/4256s5f46ht4he4r6/2014/Saivam/Azhagu-Song.mp3
    asset = [AVURLAsset assetWithURL: url];
     NSArray *requestedKeys = @[@"playable"];
   
    [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
     ^{
         dispatch_async( dispatch_get_main_queue(),
                        ^{
                            /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                            Float64 duration = CMTimeGetSeconds(asset.duration);
                            playerItem = [AVPlayerItem playerItemWithAsset: asset];
                            player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
                            
                            
                            [[NSNotificationCenter defaultCenter] addObserver:self
                                                                     selector:@selector(playerItemDidReachEnd:)
                                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                                       object:[self.player currentItem]];
                            [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
                            int hr= (int)((int)duration/60);
                            int mn=(int)((int)duration%60);
                            [totaltime setText: [NSString stringWithFormat:@"%02d:%02d",hr,mn]];
                            NSLog(@"total sec1 %f",duration);
                            [slider setMaximumValue:duration];
                              [self performSelector:@selector(configurePlayer) withObject:self afterDelay:0.2f];
                            if (![HUD isHidden]) {
                                [HUD hide:YES];
                            }

                        });
     }];
       
    
    
    
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
            
        } else if (self.player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [player play];
            
            
        } else if (self.player.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
            
        }
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    NSLog(@"AVPlayer completed");
    
}
-(void) configurePlayer {
    //7
    __block AudioPlayerViewController * weakSelf = self;
    //8
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1)
                                              queue:NULL
                                         usingBlock:^(CMTime time) {
                                             if(!time.value) {
                                                 return;
                                             }
                                             
                                             
                                             
                                             int currentTime = (int)((weakSelf.player.currentTime.value)/weakSelf.player.currentTime.timescale);
                                             int currentMins = (int)(currentTime/60);
                                             int currentSec  = (int)(currentTime%60);
                                             
                                             
                                             
                                             NSString * durationLabel =
                                             [NSString stringWithFormat:@"%02d:%02d",currentMins,currentSec];
                                             weakSelf.durationoutlet.text = durationLabel;
                                             weakSelf.slider.value = currentTime;
                                             
                                             [weakSelf.slider setValue:currentTime animated:YES];
                                         }];
    
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.player pause];
    
}
@end
