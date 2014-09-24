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
   NSLog(@"value received %@",delegate.lectureDetail);
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
    NSString *url1=@"LectureDetails.php";
    
    NSString *URLString=[NSString stringWithFormat:@"%@%@?courseid=%@&sectionid=%@&lectureid=%@",urltemp,url1,courseid,secid,lecid];
    
    NSMutableArray *search = [du MultipleCharacters:URLString];
    
    NSArray* menu = [search valueForKey:@"serviceresponse"];
    
    
    
    
    
    if ([menu count]>0)
    {
        
        NSLog(@"%@",[menu valueForKey:@"content"]);
        
        
    }
    else
    {
        
        NSLog(@"No Datas found");
    }
    //        NSLog(@"section title array %@",sectionTitleArray);
    //      NSLog(@"section content array %@",sectionContentDict);
    //         NSLog(@"section bool array %@",arrayForBool);
    
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
