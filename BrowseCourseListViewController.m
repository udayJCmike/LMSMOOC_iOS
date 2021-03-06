//
//  BrowseCourseListViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 20/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "BrowseCourseListViewController.h"
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_35 (SCREEN_HEIGHT == 480)
#define SCREEN_40 (SCREEN_HEIGHT == 568)
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface BrowseCourseListViewController ()
{
   
}
@end

@implementation BrowseCourseListViewController
int loadcompleted;
@synthesize tableView;
@synthesize course_type;
@synthesize category_tableView;
@synthesize categorylist;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

-(UIView*)initFooterView
{
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    
    UIActivityIndicatorView * actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    actInd.tag = 10;
    
    actInd.frame = CGRectMake(150.0, 5.0, 20.0, 20.0);
    
    actInd.hidesWhenStopped = YES;
    
    [footerView addSubview:actInd];
    
    [actInd startAnimating];
    return footerView;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//
//    return 50;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//
//
//    return  [self initFooterView];
//
//
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    offset=0;
    offset_free=0;
    offset_paid=0;
  
    if (SCREEN_35) {
        for (NSLayoutConstraint *con in self.view.constraints)
        {
            if (con.firstItem == tableView && con.firstAttribute == NSLayoutAttributeTop) {
                con.constant = 98;
                self.tableheightConstraint.constant = 383;
                [self.tableView needsUpdateConstraints];
                
                
            }
            if (con.firstItem == category_tableView && con.firstAttribute == NSLayoutAttributeTop) {
                con.constant = 98;
                self.categorytableheightConstraint.constant = 383;
                [self.category_tableView needsUpdateConstraints];
                
                
            }
            
            
            
        }
        
    }

    
    loadcompleted=0;
    courselist=[[NSMutableArray alloc]init];
    freecourselist=[[NSMutableArray alloc]init];
    paidlist=[[NSMutableArray alloc]init];
    
    
    
    UIButton *button2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(searchaction:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setFrame:CGRectMake(0, 0, 32, 32)];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    
    du=[[databaseurl alloc]init];
    delegate=AppDelegate;
    [self performSelector:@selector(downloadURL) withObject:self afterDelay:0.0f];
    _imageOperationQueue = [[NSOperationQueue alloc]init];
    _imageOperationQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [[NSCache alloc] init];
    [self loadDatas];
    self.category_tableView.hidden=YES;
}
-(void)downloadURL
{
    
    NSString *response=[self HttpPostEntityFirstURL1:@"name" ForValue1:@"lms"  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
    NSError *error;
    
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *parsedvalue = [json objectWithString:response error:&error];
    
  //  NSLog(@"%@ parsedvalue",parsedvalue);
    if (parsedvalue == nil)
    {
        
        //NSLog(@"parsedvalue == nil");
        
    }
    else
    {
        
        NSDictionary* menu = [parsedvalue objectForKey:@"serviceresponse"];
        
        if ([[menu objectForKey:@"success"] isEqualToString:@"Yes"])
        {
            delegate.course_image_url=[menu objectForKey:@"courseURL"];
            delegate.avatharURL=[menu objectForKey:@"avatarURL"];
            delegate.course_detail_url=[menu objectForKey:@"coursedetailURL"];
             delegate.common_url=[menu objectForKey:@"CommonUrl"];
            
        }
        
        
    }
    
}
-(NSString *)HttpPostEntityFirstURL1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Login.php?service=URL";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&%@=%@",firstEntity,value1,secondEntity,value2];
    NSURL *url = [NSURL URLWithString:url2];
    
    return [du returndbresult:post URL:url];
}

-(void)ShowAlert:(NSString*)message title:(NSString *)title
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
}
- (void)searchaction:(id)sender
{
    [self performSegueWithIdentifier:@"CourseSearch" sender:self];
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
        
        if (course_type.selectedSegmentIndex==0) {
            [self performSelector:@selector(getCourseList) withObject:self afterDelay:0.2f];
        }
        else  if (course_type.selectedSegmentIndex==1) {
            [self performSelector:@selector(getFreeCourseList) withObject:self afterDelay:0.2f];
        }
        else  if (course_type.selectedSegmentIndex==2)
        {
            [self performSelector:@selector(getPaidCourseList) withObject:self afterDelay:0.2f];
        }
        else
        {
           
            
             [self performSelector:@selector(getList) withObject:self afterDelay:0.2f];
        }
        
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
    NSString *url1=@"BrowseAllCourse.php";
  
    NSString *URLString=[NSString stringWithFormat:@"%@%@?offset=%d",urltemp,url1,offset];
    
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
        [self.tableView reloadData];
        
        
    }
    else
    {
        if ((loadcompleted==0)&&([courselist count]==0))  {
            [self ShowAlert:@"No datas found." title:@"Info"];
            
        }
        loadcompleted=1;
    }
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
   
    offset+=[courselist count];
    
    
    
    
    
}
-(void)getFreeCourseList
{
    
    
    // [courselist removeAllObjects];
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"BrowseAllCourse_Free.php";
   
    NSString *URLString=[NSString stringWithFormat:@"%@%@?offset=%d",urltemp,url1,offset_free];
    
    
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
        [self.tableView reloadData];
       
        
    }
    else
    {
        if ((loadcompleted==0)&&([courselist count]==0))  {
            [self ShowAlert:@"No datas found." title:@"Info"];
            
        }
        loadcompleted=1;
    }
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    offset_free+=[courselist count];
    
    
    
    
    
}
-(void)getPaidCourseList
{
    
    
    // [courselist removeAllObjects];
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"BrowseAllCourse_paid.php";
    
    NSString *URLString=[NSString stringWithFormat:@"%@%@?offset=%d",urltemp,url1,offset_paid];
    
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
        [self.tableView reloadData];
      
        
    }
    else
    {
        if ((loadcompleted==0)&&([courselist count]==0))  {
            [self ShowAlert:@"No data found." title:@"Info"];
            
        }
        loadcompleted=1;
    }
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    offset_paid+=[courselist count];
    
    
    
    
    
}
-(void)getList
{
    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSString *response=[self HttpPostEntityFirst1:@"studentid" ForValue1:userid  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
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
        NSArray *Listofdatas=[menu objectForKey:@"Category List"];
        
        //  NSLog(@"listof datas values %@",Listofdatas);
        
        if ([Listofdatas count]>0)
        {
            categorylist=[[NSMutableArray alloc]init];
            
            for (id list in Listofdatas)
            {
                NSDictionary *arrayList1=[(NSDictionary*)list objectForKey:@"serviceresponse"];
                [categorylist addObject:[arrayList1 objectForKey:@"category_name"]];
                
            }
        }
        else
        {
            
        }
        
        [category_tableView reloadData];
        // NSLog(@"list values %@",inbox);
        
    }
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    
    
}
-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Categories.php?service=Categorylist";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&%@=%@",firstEntity,value1,secondEntity,value2];
    NSURL *url = [NSURL URLWithString:url2];
   // NSLog(@"%@ url",url2     );
    return [du returndbresult:post URL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        return [courselist count];
    }
    else
        return [categorylist count];
    
    // Return the number of rows in the section.
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    UITableView *temptb=tableView;
    if (temptb.tag==1)
    {
        CourseDesignTableViewCell *cell = (CourseDesignTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"CourseList" forIndexPath:indexPath];
        NSDictionary *course;
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        course=[courselist objectAtIndex:indexPath.row];
        cell.coursename.text=[course objectForKey:@"course_name"];
        cell.authorname.text=[course objectForKey:@"course_author"];
        cell.price.text=[NSString stringWithFormat:@"$ %@",[course objectForKey:@"course_price"]];
        cell.cover.image=[UIImage imageNamed:[course objectForKey:@"course_cover_image"]];
        cell.numberofpurchased.text=[NSString stringWithFormat:@"%@ students",[course objectForKey:@"numofpurchased"]];
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
        
        NSString *promo=[course objectForKey:@"promocode_available"];
        if ([promo isEqualToString:@"1"]) {
           cell.promoimage.hidden=NO;
        }
        else
        {
            cell.promoimage.hidden=YES;
        }

        
        // cell.review.image=[UIImage imageNamed:@"1star"];
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
    else
    {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        
        cell = [self.category_tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.textLabel.text = [categorylist objectAtIndex:indexPath.row];
        //  NSLog(@"category data %@", cell.textLabel.text);
        return cell;
    }
    
    return cell;
    
}

- (void)menulistener:(id)sender {
    
    
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Showmenu" object:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1)
    {
        
        
        NSDictionary *temp=[courselist objectAtIndex:indexPath.row];
         NSString *url=[NSString stringWithFormat:@"%@?course_id=%@&authorid=%@&pur=%@&catcourse=&coursetype=",delegate.course_detail_url,[temp objectForKey:@"course_id"], [temp objectForKey:@"instructor_id"],[temp objectForKey:@"numofpurchased"]];
        // NSLog(@"URL %@",url);
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }
    else if (tableView.tag==2)
    {
        [self performSegueWithIdentifier:@"CourseDatas" sender:self];
    }
    
}

- (IBAction)course_type:(UISegmentedControl*)sender {
    
    if (sender.selectedSegmentIndex==0) {
        course_type_val=@"All";
        offset=0;
        loadcompleted=0;
        [courselist removeAllObjects];
        [_imageOperationQueue cancelAllOperations];
        self.tableView.hidden=NO;
        self.category_tableView.hidden=YES;
        [self loadDatas];
        [self.tableView reloadData];
    }
    else  if (sender.selectedSegmentIndex==1) {
        course_type_val=@"Free";
        offset_free=0;
        loadcompleted=0;
        [courselist removeAllObjects];
        [_imageOperationQueue cancelAllOperations];
        self.tableView.hidden=NO;
        self.category_tableView.hidden=YES;
        [self loadDatas];
        [self.tableView reloadData];
    }
    else  if (sender.selectedSegmentIndex==2) {
        course_type_val=@"Paid";
        offset_paid=0;
        loadcompleted=0;
        [courselist removeAllObjects];
        self.tableView.hidden=NO;
        [_imageOperationQueue cancelAllOperations];
        self.category_tableView.hidden=YES;
        [self loadDatas];
        [self.tableView reloadData];
    }
    else  if (sender.selectedSegmentIndex==3) {
        course_type_val=@"Category";
        self.tableView.hidden=YES;
        self.category_tableView.hidden=NO;
//        offset_paid=0;
//        loadcompleted=0;
//        [courselist removeAllObjects];
        [_imageOperationQueue cancelAllOperations];
        [self loadDatas];
        [self.category_tableView reloadData];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"CourseDatas"]) {
        NSIndexPath *indexpath=[self.category_tableView indexPathForSelectedRow];
        CategorywiseDatasViewController *vc=[segue destinationViewController];
        vc.categoryname=[categorylist objectAtIndex:indexpath.row];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Showmenu" object:nil];
            HUD.delegate = nil;
    
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadDatas) object:self];
    [super dealloc];
}
@end
