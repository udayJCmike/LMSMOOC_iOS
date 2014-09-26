//
//  BrowseCourseSearchViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 20/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "BrowseCourseSearchViewController.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface BrowseCourseSearchViewController ()

@end

@implementation BrowseCourseSearchViewController

@synthesize coursename;
int loadcompleted;
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
    offset=0;
    loadcompleted=0;
    courselist=[[NSMutableArray alloc]init];
    du=[[databaseurl alloc]init];
    delegate=AppDelegate;
    _imageOperationQueue = [[NSOperationQueue alloc]init];
    _imageOperationQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [[NSCache alloc] init];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
    if ([textField.text length]>0) {
        offset=0;
        loadcompleted=0;
        [courselist removeAllObjects];
        [_imageOperationQueue cancelAllOperations];
        [self loadDatas];
    }
    else
    {
        [HUD hide:YES];
    }
    return YES;
}

-(void)loadDatas
{
    if ([[du submitvalues]isEqualToString:@"Success"])
    {
        [self getCourseList];
        
        
        
        
        
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

-(void)getCourseList
{
    
    du=[[databaseurl alloc]init];
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"CourseSearch.php";
    NSString *course= [coursename.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
   
    NSString *URLString=[NSString stringWithFormat:@"%@%@?offset=%d&course=%@",urltemp,url1,offset,course];
    
    NSMutableArray *search = [du MultipleCharacters:URLString];
    
    NSDictionary* menu = [search valueForKey:@"serviceresponse"];
    
    NSArray *Listofdatas=[menu objectForKey:@"Course List"];
    
    
    if ([Listofdatas count]>0)
    {
        
        
        for (int i=0;i<[Listofdatas count];i++)
        {
            NSDictionary *arrayList1= [Listofdatas objectAtIndex:i];
            NSDictionary *temp=[arrayList1 objectForKey:@"serviceresponse"];
            //            NSLog(@"Received Values %@",temp);
            [courselist addObject:temp];
            
            
        }
        [self.tableView reloadData];
        if (![HUD isHidden]) {
            [HUD hide:YES];
        }
        // NSLog(@"arrat Datas found---- %@",courselist);
    }
    else
    {
        loadcompleted=1;
        NSLog(@"No Datas found");
    }
    offset+=10;
    
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [courselist count];
    
    // Return the number of rows in the section.
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CourseDesignTableViewCell *cell = (CourseDesignTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"CourseList" forIndexPath:indexPath];
    NSDictionary *course;
    
    
    course=[courselist objectAtIndex:indexPath.row];
    cell.coursename.text=[course objectForKey:@"course_name"];
    cell.authorname.text=[course objectForKey:@"course_author"];
    cell.price.text=[course objectForKey:@"course_price"];
    cell.cover.image=[UIImage imageNamed:[course objectForKey:@"course_cover_image"]];
    //  cell.review.image=[UIImage imageNamed:[course objectForKey:@"ratings"]];
    
    NSString * rating =[course objectForKey:@"ratings"];
    
    //  NSLog(@"rating %@",rating);
    if([rating isEqualToString:@"1"])
    {
        cell.review.image=[UIImage imageNamed:@"1star"];
    }
    else if([rating isEqualToString:@"2"])
    {
        cell.review.image=[UIImage imageNamed:@"2star"];
    }
    else if([rating isEqualToString:@"3"])
    {
        cell.review.image=[UIImage imageNamed:@"3star"];
    }
    else if([rating isEqualToString:@"4"])
    {
        cell.review.image=[UIImage imageNamed:@"4star"];
    }
    else if([rating isEqualToString:@"5"])
    {
        cell.review.image=[UIImage imageNamed:@"5star"];
    }
    else
    {
        cell.review.image=[UIImage imageNamed:@"0star"];
    }
    
    
    NSString *imageUrlString = [[NSString alloc]initWithFormat:@"%@/%@/%@",delegate.course_image_url,[course objectForKey:@"course_id"],[course objectForKey:@"course_cover_image"]];
    
    UIImage *imageFromCache = [self.imageCache objectForKey:imageUrlString];
    
    if (imageFromCache) {
        cell.cover.image= imageFromCache;
        // set your frame accordingly
    }
    else
    {
        cell.cover.image = [UIImage imageNamed:@"placeholder"];
        
        
        [self.imageOperationQueue addOperationWithBlock:^{
            NSURL *imageurl = [NSURL URLWithString:imageUrlString];
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageurl]];
            
            if (img != nil) {
                
                // update cache
                [self.imageCache setObject:img forKey:imageUrlString];
                
                // now update UI in main queue
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // see if the cell is still visible ... it's possible the user has scrolled the cell so it's no longer visible, but the cell has been reused for another indexPath
                    CourseDesignTableViewCell *updateCell = (CourseDesignTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    // if so, update the image
                    if (updateCell) {
                        // I don't know what you want to set this to, but make sure to set it appropriately for your cell; usually I don't mess with the frame.
                        [updateCell.cover setImage:img];
                    }
                }];
            }
        }];
    }
    
    
    if (indexPath.row == [courselist count] - 1)
    {
        if (loadcompleted!=1) {
            [self loadDatas];
        }
    }
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    NSDictionary *temp=[courselist objectAtIndex:indexPath.row];
    NSString *url=[NSString stringWithFormat:@"http://208.109.248.89:8087/OnlineCourse/student_view_Course?course_id=%@&authorid=%@&pur=%@&catcourse=&coursetype=",[temp objectForKey:@"course_id"], [temp objectForKey:@"instructor_id"],[temp objectForKey:@"numofpurchased"]];
    // NSLog(@"URL %@",url);
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    
    
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