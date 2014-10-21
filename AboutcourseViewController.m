//
//  AboutcourseViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 22/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "AboutcourseViewController.h"
#import "databaseurl.h"


@interface AboutcourseViewController ()
{
   
}
@end

@implementation AboutcourseViewController
@synthesize course_des;
@synthesize removefromfav;
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
    if (SCREEN_35) {
        for (NSLayoutConstraint *con in self.view.constraints)
        {
            if (con.firstItem == self.scrollheight && con.firstAttribute == NSLayoutAttributeTop) {
                
                self.scrollbottom.constant = 100;
                [self.scrollheight needsUpdateConstraints];
                
                
            }
        }
    }
    else if(SCREEN_40)
    {
        for (NSLayoutConstraint *con in self.view.constraints)
        {
            if (con.firstItem == self.scrollheight && con.firstAttribute == NSLayoutAttributeTop) {
                
                self.scrollbottom.constant = 50;
                [self.scrollheight needsUpdateConstraints];
                
                
            }
        }
    }
    du=[[databaseurl alloc]init];
       course_des.text=[delegate.CourseDetail valueForKey:@"course_description"];
   // NSLog(@"delegate.coursedetail %@",delegate.CourseDetail);
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
    [self performSelector:@selector(searchcourse) withObject:self afterDelay:0.1f];
    
    // Do any additional setup after loading the view.
}
-(void)searchcourse
{
    NSString* studentid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSString *response=[self HttpPostEntityFirstsearch:@"studentid" ForValue1:studentid  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
    NSError *error;
    //NSLog(@"response %@",response);
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
        if (([[menu objectForKey:@"success"]isEqualToString:@"Yes"])&&([[menu objectForKey:@"fav"]isEqualToString:@"1"]))
        {
          
            [removefromfav setTitle:@"Remove From Favorites" forState:UIControlStateNormal];
              [self.removefromfav warningStyle];
        }
        else  if (([[menu objectForKey:@"success"]isEqualToString:@"Yes"])&&([[menu objectForKey:@"fav"]isEqualToString:@"0"]))
        {
           
            [removefromfav setTitle:@"Add to Favorites" forState:UIControlStateNormal];
             [self.removefromfav successStyle];
        }
        else
        {
            // NSLog(@"failure");
            
        }
        
    }
    
    [HUD hide:YES];


}
-(void)removefromfavfuntion
{
    
}
- (IBAction)removefromfav:(UIButton*)sender {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
    [self performSelector:@selector(removefromfavfuntion) withObject:self afterDelay:0.1f ];
    
    NSString* studentid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSString *response;
    
    if ([sender.titleLabel.text isEqualToString:@"Add to Favorites"])
    {
        response=[self HttpPostEntityFirstfollow1:@"studentid" ForValue1:studentid  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
        [self.removefromfav warningStyle];
        [removefromfav setTitle:@"Remove From Favorites" forState:UIControlStateNormal];
    }
    else if ([sender.titleLabel.text isEqualToString:@"Remove From Favorites"])
    {
        response=[self HttpPostEntityFirst1:@"studentid" ForValue1:studentid  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
        [self.removefromfav successStyle];
        [removefromfav setTitle:@"Add to Favorites" forState:UIControlStateNormal];
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
            // NSLog(@"failure");
            
        }
        
    }
    
    [HUD hide:YES];
    
    
    
}

-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Myfavorites_remove.php?service=RemoveCourse";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&courseid=%@&%@=%@",firstEntity,value1,[delegate.CourseDetail valueForKey:@"course_id"],secondEntity,value2];
    // NSLog(@"Post for remove author %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    
    return [du returndbresult:post URL:url];
}
-(NSString *)HttpPostEntityFirstfollow1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Myfavorites_remove.php?service=AddCourse";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&courseid=%@&course_name=%@&%@=%@",firstEntity,value1,[delegate.CourseDetail valueForKey:@"course_id"],[delegate.CourseDetail valueForKey:@"course_name"],secondEntity,value2];
    // NSLog(@"Post for add author %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    
    return [du returndbresult:post URL:url];
}
-(NSString *)HttpPostEntityFirstsearch:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Myfavorites_remove.php?service=SearchCourse";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&courseid=%@&%@=%@",firstEntity,value1,[delegate.CourseDetail valueForKey:@"course_id"],secondEntity,value2];
   // NSLog(@"Post for add author %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    
    return [du returndbresult:post URL:url];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}
@end
