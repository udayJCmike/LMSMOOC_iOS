//
//  AudioPlayerViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 24/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface AudioPlayerViewController ()
{
    AVPlayerItem *playerItem;
    AVPlayer *player;
    
    
}
@property(nonatomic,strong) AVPlayer *player;
@end


@implementation AudioPlayerViewController
@synthesize audioname;
@synthesize toggleplaypause;
@synthesize slider;
@synthesize durationoutlet;
@synthesize totaltime;
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
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
    durationoutlet.text=@"00:00";
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
    
     //  NSLog(@"menu search %@",search);
    
    
    
    if ([menu count]>0)
    {
        
       // NSLog(@"%@",[menu valueForKey:@"lecture_audio"]);
        audioname=[menu valueForKey:@"lecture_audio"];
        
        
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
    
  
    
    if ([audioname length]>0) {
        [self performSelector:@selector(playselectedsong) withObject:self afterDelay:5.0f];
        [self performSelector:@selector(configurePlayer) withObject:self afterDelay:5.0f];
        
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
   
    NSURL *url = [NSURL URLWithString:@"http://tamilmp3hub.com/4256s5f46ht4he4r6/2014/Saivam/Azhagu-Song.mp3"];
    AVURLAsset *asset = [AVURLAsset assetWithURL: url];
    
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    
    Float64 duration = CMTimeGetSeconds(asset.duration);
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
    self.player = [[AVPlayer alloc] initWithPlayerItem: item];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.player currentItem]];
    [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
    //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
    //  [self.slider setMaximumValue:self.player.currentItem.duration.value/self.player.currentItem.duration.timescale];
    //    CMTime duration = playerItem.duration; //total time
    //    CMTime currentTime = playerItem.currentTime; //playing time
    //    CMTime t = player.currentItem.duration;
    //    float secs = CMTimeGetSeconds(t);
    
    //    NSLog(@"total sec %f",secs);
  //  NSLog(@"total sec1 %f",duration);
       int hr= (int)((int)duration/60);
        int mn=(int)((int)duration%60);
        [totaltime setText: [NSString stringWithFormat:@"%02d:%02d",hr,mn]];
    [slider setMaximumValue:duration];
    
    
    
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



@end
