//
//  AboutauthorViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 22/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "AboutauthorViewController.h"

@interface AboutauthorViewController ()

@end

@implementation AboutauthorViewController
@synthesize authorname;
@synthesize edu;
@synthesize aboutme;
@synthesize avatar;
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
     delegate=AppDelegate;
    _imageOperationQueue = [[NSOperationQueue alloc]init];
    _imageOperationQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [[NSCache alloc] init];

    
    du=[[databaseurl alloc]init];
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
        [self getAuthorDatas];
        
        
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
-(void)getAuthorDatas
{
    
    NSString*instructorid=[delegate.CourseDetail valueForKey:@"instructor_id"];
    NSLog(@"instructor id %@",instructorid);
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"InstructorDetails.php";
    
    NSString *URLString=[NSString stringWithFormat:@"%@%@?insid=%@",urltemp,url1,instructorid];
    
    NSMutableArray *search = [du MultipleCharacters:URLString];
    
    NSDictionary* menu = [search valueForKey:@"serviceresponse"];
    
    NSString *imagepath;
    
    
    
    if ([menu count]>0)
    {
        NSString *fname=[menu valueForKey:@"firstname"];
        NSString *lname=[menu valueForKey:@"lastname"];
       authorname.text= [NSString stringWithFormat:@"%@ %@",fname,lname];
        edu.text= [menu valueForKey:@"education"];
        aboutme.text= [menu valueForKey:@"aboutme"];
       
        imagepath=[NSString stringWithFormat:@"%@%@",delegate.avatharURL,[menu valueForKey:@"avatar"]];
        
    }
    else
    {
        
        NSLog(@"No Datas found");
    }
    
    UIImage *imageFromCache = [self.imageCache objectForKey:imagepath];
    if (imageFromCache) {
        avatar.image=imageFromCache;
    }
    else
    {
        avatar.image = [UIImage imageNamed:@"placeholder"];
        [self.imageOperationQueue addOperationWithBlock:^{
            NSURL *imageurl = [NSURL URLWithString:imagepath];
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageurl]];
            
            if (img != nil) {
                
                // update cache
                [self.imageCache setObject:img forKey:imagepath];
                
                // now update UI in main queue
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                     avatar.image=img;
                   
                }];
            }
        }];
    }
    


    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    
    
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
     [_imageOperationQueue cancelAllOperations];
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
