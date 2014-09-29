//
//  CourseDetailViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 22/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "CourseDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>
@interface CourseDetailViewController ()
@property (strong, nonatomic) MPMoviePlayerController *videoPlayer;
@property (strong, nonatomic) MPMoviePlayerViewController *videoViewController;
@end

@implementation CourseDetailViewController
@synthesize coursename;
@synthesize enrolledstu;
@synthesize review;
@synthesize SelectedCourse;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSString *)setimage:(NSString*)ratings
{
    
    if ([ratings isEqualToString:@"0"]) {
        return @"0star.png";
    }
    else if ([ratings isEqualToString:@"1"]) {
        return @"1star.png";
    }
    else if ([ratings isEqualToString:@"2"]) {
        return @"2star.png";
    }
    else if ([ratings isEqualToString:@"3"]) {
        return @"3star.png";
    }
    else if ([ratings isEqualToString:@"4"]) {
        return @"4star.png";
    }
    else if ([ratings isEqualToString:@"5"]) {
        return @"5star.png";
    }
    return @"0star.png";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    delegate=AppDelegate;
   SelectedCourse= delegate.CourseDetail;
    self.dataSource = self;
    self.delegate = self;
    enrolledstu.text= [SelectedCourse objectForKey:@"numofpurchased"];
    review.image=[UIImage imageNamed:[self setimage:[SelectedCourse objectForKey:@"ratings"]]];
    coursename.text=[SelectedCourse objectForKey:@"course_name"];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0.1f];
    

    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
}
#pragma mark - Setters
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    
    // Reload data
    [self reloadData];
    
}

- (void)loadContent {
    self.numberOfTabs = 3;
    NSString *videoname=[SelectedCourse objectForKey:@"course_promo_video"];
     NSString*courseid= [SelectedCourse objectForKey:@"course_id"];
    NSString *imageUrlString = [[NSString alloc]initWithFormat:@"%@%@/%@",delegate.course_image_url,courseid,videoname];
   // NSLog(@"promo video url %@",imageUrlString);
 NSURL *url = [NSURL URLWithString:imageUrlString];
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    player.view.frame = CGRectMake(16, 95, 289, 106);
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        player.view.frame = CGRectMake(33, 141, 425, 178);
    }
    [self.view addSubview:player.view];
    [player prepareToPlay];
    [player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
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
//            [self dismissMoviePlayerViewControllerAnimated];
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.numberOfTabs;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.0];
    if (index==0) {
       label.text = [NSString stringWithFormat:@"Syllabus"];
    }
    if (index==1) {
       label.text = [NSString stringWithFormat:@"About Course"];
    }
    if (index==2) {
        label.text = [NSString stringWithFormat:@"About Author"];
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    SyllabusViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SyllabusViewController"];
    if (index==0) {
          SyllabusViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SyllabusViewController"];
        return cvc;
        
    }
    else if (index==1) {
        AboutcourseViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutcourseViewController"];
        return cvc;
        
            
        }
    else if (index==2) {
        
        AboutauthorViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutauthorViewController"];
        return cvc;
    }
  
    
   
    
    return cvc;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return 49.0;
        case ViewPagerOptionTabOffset:
            return 36.0;
        case ViewPagerOptionTabWidth:
            return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 128.0 : 96.0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 1.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 1.0;
        default:
            return value;
    }
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor redColor] colorWithAlphaComponent:0.64];
        case ViewPagerTabsView:
            return [[UIColor lightGrayColor] colorWithAlphaComponent:0.32];
        case ViewPagerContent:
            return [[UIColor darkGrayColor] colorWithAlphaComponent:0.32];
        default:
            return color;
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
