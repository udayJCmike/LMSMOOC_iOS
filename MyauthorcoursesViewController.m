//
//  MyauthorcoursesViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 18/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "MyauthorcoursesViewController.h"

@interface MyauthorcoursesViewController ()

@end

@implementation MyauthorcoursesViewController
@synthesize authorid;
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
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
    _imageOperationQueue = [[NSOperationQueue alloc]init];
    _imageOperationQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [[NSCache alloc] init];
    
    NSLog(@"authorid received %@",authorid);
    if (self.navigationController.navigationBar.hidden == YES)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    
    UIButton *button2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"Remove From favorites" forState:UIControlStateNormal];
    // [button2 setTitle:@"Add to favorites" forState:UIControlStateSelected];
    [button2 addTarget:self action:@selector(removeAuthorname) forControlEvents:UIControlEventTouchUpInside];
    [button2 setFrame:CGRectMake(0, 0, 180, 32)];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.title=_authorname;
    [self loadDatas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)removeAuthorname
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
    
    
    NSString* studentid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSString *response=[self HttpPostEntityFirst1:@"studentid" ForValue1:studentid  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveStatus"
                                                                object:@"success"
                                                              userInfo:nil];
        }
        else
        {
            NSLog(@"failure");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveStatus"
                                                                object:@"failure"
                                                              userInfo:nil];
        }
        
    }
    
    [HUD hide:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    offset=0;
    loadcompleted=0;
    [courselist removeAllObjects];
    [_imageOperationQueue cancelAllOperations];
    
}
-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Myauthor.php?service=RemoveAuthor";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&authorid=%@&%@=%@",firstEntity,value1,authorid,secondEntity,value2];
    NSURL *url = [NSURL URLWithString:url2];
    
    return [du returndbresult:post URL:url];
}





// Do any additional setup after loading the view.

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
    
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"MyauthorDatas.php";
    
    NSString *URLString=[NSString stringWithFormat:@"%@%@?offset=%d&authorid=%@",urltemp,url1,offset,authorid];
    
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
    NSString *url=[NSString stringWithFormat:@"http://208.109.248.89:8085/OnlineCourse/student_view_Course?course_id=%@&authorid=%@&pur=%@&catcourse=&coursetype=",[temp objectForKey:@"course_id"], [temp objectForKey:@"instructor_id"],[temp objectForKey:@"numofpurchased"]];
    // NSLog(@"URL %@",url);
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    
    
}




@end
