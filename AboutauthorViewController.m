//
//  AboutauthorViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 22/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "AboutauthorViewController.h"
#import "UIButton+Bootstrap.h"

@interface AboutauthorViewController ()

@end

@implementation AboutauthorViewController
@synthesize authorname;
@synthesize edu;
@synthesize aboutme;
@synthesize avatar;
@synthesize followbutton;
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
    if (SCREEN_35) {
        for (NSLayoutConstraint *con in self.view.constraints)
        {
            if (con.firstItem == self.scrollheight && con.firstAttribute == NSLayoutAttributeTop) {
                
            self.scrollbottom.constant = 100;
                [self.scrollheight needsUpdateConstraints];
                
                
            }
        }
    }
     delegate=AppDelegate;
    _imageOperationQueue = [[NSOperationQueue alloc]init];
    _imageOperationQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [[NSCache alloc] init];

    
    du=[[databaseurl alloc]init];
       [self loadDatas];
    
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
        [self performSelector:@selector(getAuthorDatas) withObject:self afterDelay:0.1f];
        
        
        
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
    NSString *userid=[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
    //NSLog(@"instructor id %@",instructorid);
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"InstructorDetails.php";
    
    NSString *URLString=[NSString stringWithFormat:@"%@%@?insid=%@&stuid=%@",urltemp,url1,instructorid,userid];
    
    NSMutableArray *search = [du MultipleCharacters:URLString];
    
    NSDictionary* menu = [search valueForKey:@"serviceresponse"];
    
    NSString *imagepath;
    
  //  NSLog(@"menu %@",menu);
    
    if ([menu count]>0)
    {
        NSString *fname=[menu valueForKey:@"firstname"];
        NSString *lname=[menu valueForKey:@"lastname"];
       authorname.text= [NSString stringWithFormat:@"%@ %@",fname,lname];
        edu.text= [menu valueForKey:@"education"];
        aboutme.text= [menu valueForKey:@"aboutme"];
        follow= [menu valueForKey:@"follow"];
        imagepath=[NSString stringWithFormat:@"%@%@",delegate.avatharURL,[menu valueForKey:@"avatar"]];
        if ([follow isEqualToString:@"0"]) {
            [self.followbutton successStyle];
            [followbutton setTitle:@"Follow Author" forState:UIControlStateNormal];
        }
        else 
        {
            [self.followbutton warningStyle];
        [followbutton setTitle:@"Unfollow Author" forState:UIControlStateNormal];
        }
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
- (IBAction)removeauthorfromfav:(UIButton*)sender {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
    NSString* studentid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSString *response;
    
    if ([sender.titleLabel.text isEqualToString:@"Follow Author"])
    {
     response=[self HttpPostEntityFirstfollow1:@"studentid" ForValue1:studentid  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
         [self.followbutton warningStyle];
        [followbutton setTitle:@"Unfollow Author" forState:UIControlStateNormal];
    }
    else if ([sender.titleLabel.text isEqualToString:@"Unfollow Author"])
    {
        response=[self HttpPostEntityFirst1:@"studentid" ForValue1:studentid  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
         [self.followbutton successStyle];
        [followbutton setTitle:@"Follow Author" forState:UIControlStateNormal];
    }
    
  
    NSError *error;
    //  NSLog(@"response %@",response);
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *parsedvalue = [json objectWithString:response error:&error];
    
    // NSLog(@"%@ parsedvalue",parsedvalue);
    if (parsedvalue == nil)
    {
        
        //NSLog(@"parsedvalue == nil");
        
    }
    else
    {
        NSDictionary* menu = [parsedvalue objectForKey:@"serviceresponse"];
        if ([[menu objectForKey:@"success"]isEqualToString:@"Yes"]) {
           
        }
        else
        {
            NSLog(@"failure");
    
        }
        
    }
    
    [HUD hide:YES];
   
    
    
}

-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Myauthor.php?service=RemoveAuthor";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&authorid=%@&%@=%@",firstEntity,value1,[delegate.CourseDetail valueForKey:@"instructor_id"],secondEntity,value2];
   // NSLog(@"Post for remove author %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    
    return [du returndbresult:post URL:url];
}
-(NSString *)HttpPostEntityFirstfollow1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Myauthor.php?service=AddAuthor";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&authorid=%@&authorname=%@&%@=%@",firstEntity,value1,[delegate.CourseDetail valueForKey:@"instructor_id"],authorname.text,secondEntity,value2];
   // NSLog(@"Post for add author %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    
    return [du returndbresult:post URL:url];
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

- (void)dealloc {
  
    [super dealloc];
}
@end
