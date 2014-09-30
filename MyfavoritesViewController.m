//
//  MyfavoritesViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 18/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "MyfavoritesViewController.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface MyfavoritesViewController ()

@end

@implementation MyfavoritesViewController

@synthesize studentid;
int loadcompleted;


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
    
    
    if (self.navigationController.navigationBar.hidden == YES)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(menulistener:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menulistener:)
                                                 name:@"Showmenu"
                                               object:nil];
    [self loadDatas];
}

- (void)menulistener:(id)sender {
    
    
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Showmenu" object:nil];
}





// Do any additional setup after loading the view.

-(void)loadDatas
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
    if ([[du submitvalues]isEqualToString:@"Success"])
    {
        
        [self performSelector:@selector(getCourseList) withObject:self afterDelay:0.2f];
        
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
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    offset=0;
//    loadcompleted=0;
//    [courselist removeAllObjects];
    [_imageOperationQueue cancelAllOperations];
    
}
-(void)getCourseList
{
    
    studentid= [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Myfavorites.php";
    
    NSString *URLString=[NSString stringWithFormat:@"%@%@?offset=%d&studentid=%@",urltemp,url1,offset,studentid];
    
    NSMutableArray *search = [du MultipleCharacters:URLString];
    
    NSDictionary* menu = [search valueForKey:@"serviceresponse"];
    
    NSArray *Listofdatas=[menu objectForKey:@"Course List"];
    
    
    if ([Listofdatas count]>0)
    {
        
        
        for (int i=0;i<[Listofdatas count];i++)
        {
            NSDictionary *arrayList1= [Listofdatas objectAtIndex:i];
            NSDictionary *temp=[arrayList1 objectForKey:@"serviceresponse"];
            NSString* mess=[temp objectForKey:@"course_description"];
            mess = [mess stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
            mess = [mess stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
            [temp setValue:mess forKey:@"course_description"];
            //            NSLog(@"Received Values %@",temp);
            [courselist addObject:temp];
            
            
        }
        
        
    }
    else
    {
        loadcompleted=1;
        NSLog(@"No Datas found");
    }
    [self.tableView reloadData];
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    offset+=10;
    
    
    
    
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CourseDesignTableViewCell *cell = (CourseDesignTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"CourseList" forIndexPath:indexPath];
    NSDictionary *course;
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    course=[courselist objectAtIndex:indexPath.row];
    cell.coursename.text=[course objectForKey:@"course_name"];
    cell.authorname.text=[course objectForKey:@"course_author"];
    cell.price.text=[course objectForKey:@"course_price"];
    cell.cover.image=[UIImage imageNamed:[course objectForKey:@"course_cover_image"]];
    [self setimage:[course objectForKey:@"ratings"]];
    cell.review.image=[UIImage imageNamed:[self setimage:[course objectForKey:@"ratings"]]];
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
    if([[temp objectForKey:@"studentenrolled"]isEqualToString:@"0"])
    {
        NSString *url=[NSString stringWithFormat:@"http://208.109.248.89:8087/OnlineCourse/student_view_Course?course_id=%@&authorid=%@&pur=%@&catcourse=&coursetype=",[temp objectForKey:@"course_id"], [temp objectForKey:@"instructor_id"],[temp objectForKey:@"numofpurchased"]];
        // NSLog(@"URL %@",url);
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }
    else
    {
        NSLog(@"Student enrolled");
        delegate.CourseDetail=[courselist objectAtIndex:indexPath.row];
        
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            
            UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"CourseDetailiPad" bundle:nil];
            UIViewController *initialvc=[welcome instantiateInitialViewController];
            [self.navigationController pushViewController:initialvc animated:YES];
            
        }
        else if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"CourseDetailiPhone" bundle:nil];
            UIViewController *initialvc=[welcome instantiateInitialViewController];
            [self.navigationController pushViewController:initialvc animated:YES];
        }

    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    HUD.delegate = nil;
}
@end
