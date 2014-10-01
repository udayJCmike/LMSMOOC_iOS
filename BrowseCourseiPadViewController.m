//
//  BrowseCourseiPadViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 20/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "BrowseCourseiPadViewController.h"

#import "Courselist_iPad_ViewController.h"
#import "REFrostedViewController.h"
#import "CategorywiseDatasiPadViewController.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface BrowseCourseiPadViewController ()

@end

@implementation BrowseCourseiPadViewController

@synthesize course_type;

@synthesize ipadcollection;
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
    [course_type setSegmentedControlStyle:UISegmentedControlStylePlain];
    loadcompleted=0;
    offset=0;
    offset_free=0;
    offset_paid=0;
    
    courselist=[[NSMutableArray alloc]init];
    freecourselist=[[NSMutableArray alloc]init];
    paidlist=[[NSMutableArray alloc]init];
    
    
    UIButton *button2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(searchaction:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setFrame:CGRectMake(0, 0, 32, 32)];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    
    ipadcollection.dataSource=self;
    ipadcollection.delegate=self;
    du=[[databaseurl alloc]init];
    delegate=AppDelegate;
     [self performSelector:@selector(downloadURL) withObject:self afterDelay:0.0f];
     _imageOperationQueue = [[NSOperationQueue alloc]init];
    _imageOperationQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [[NSCache alloc] init];
    [self loadDatas];
    
    /*   NSArray *buttonNames = [NSArray arrayWithObjects:@"All", @"Free", @"Paid", @"Category", nil];
     course_type = [[UISegmentedControl alloc]
     initWithItems:buttonNames];
     course_type .segmentedControlStyle = UISegmentedControlStyleBar;
     course_type.momentary = YES;
     [course_type addTarget:self action:@selector(course_type:)
     forControlEvents:UIControlEventValueChanged];
     course_type.selectedSegmentIndex=0;
     course_type.tintColor=[UIColor colorWithRed:66.0/255.0 green:139.0/255.0 blue:202.0/255.0 alpha:1];
     // Add it to the navigation bar
     self.navigationItem.titleView = course_type;*/
}
-(void)downloadURL
{
    
    NSString *response=[self HttpPostEntityFirstURL1:@"name" ForValue1:@"lms"  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
    NSError *error;
    
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self callsegment];
    
   
   

}
-(void)callsegment
{
    if (course_type.selectedSegmentIndex==3) {
        
        [course_type setSelectedSegmentIndex:0];
        [course_type sendActionsForControlEvents:UIControlEventValueChanged];
        
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
    
    NSMutableArray *olddata=courselist;
    //  NSLog(@"array values in all course b4 updating %@",courselist);
    if ([Listofdatas count]>0)
    {
        
        
        for (int i=0;i<[Listofdatas count];i++)
        {
            NSDictionary *arrayList1= [Listofdatas objectAtIndex:i];
            NSDictionary* temp=[arrayList1 objectForKey:@"serviceresponse"];
            NSString* mess=[temp objectForKey:@"course_description"];
            mess = [mess stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
            mess = [mess stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
            [temp setValue:mess forKey:@"course_description"];
            
            [olddata addObject:temp];
            
            
        }
        
        
        
    }
    else
    {
        loadcompleted=1;
    }
    if (![HUD isHidden])
    {
        [HUD hide:YES];
        
    }
    
    courselist=[[NSMutableArray alloc]init];
    courselist=olddata;
    offset+=10;
    // NSLog(@"array values in all course after updating %@",courselist);
    [self performSelector:@selector(reloaddatas) withObject:nil afterDelay:0.5f];
    
    
    
    
    
}
-(void)getFreeCourseList
{
    
    
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
            NSDictionary* temp=[arrayList1 objectForKey:@"serviceresponse"];
            //            NSLog(@"Received Values %@",temp);
            NSString* mess=[temp objectForKey:@"course_description"];
            mess = [mess stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
            mess = [mess stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
            [temp setValue:mess forKey:@"course_description"];

            
            [courselist   addObject:temp];
            
            
        }
        
        
    }
    else
    {
        loadcompleted=1;
    }
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    offset_free+=10;
    [self performSelector:@selector(reloaddatas) withObject:nil afterDelay:0.5f];
    
    
    
    
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
            NSDictionary* temp=[arrayList1 objectForKey:@"serviceresponse"];
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
    }
    
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    
    
    offset_paid+=10;
    [self performSelector:@selector(reloaddatas) withObject:nil afterDelay:0.5f];
    
    
    
    
}

-(void)reloaddatas
{
    [self.ipadcollection reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return courselist.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //     NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
   // NSLog(@"clicked at index %d",indexPath.row);
    NSDictionary *temp=[courselist objectAtIndex:indexPath.row];
    NSString *url=[NSString stringWithFormat:@"%@?course_id=%@&authorid=%@&pur=%@&catcourse=&coursetype=",delegate.course_detail_url,[temp objectForKey:@"course_id"], [temp objectForKey:@"instructor_id"],[temp objectForKey:@"numofpurchased"]];
    // NSLog(@"URL %@",url);
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CourseList";
    
    
    CollectionCellContent *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSDictionary *course;
    course=[courselist objectAtIndex:indexPath.row];
    cell.coursename.text=[course objectForKey:@"course_name"];
    cell.authorname.text=[course objectForKey:@"course_author"];
    cell.price.text=[course objectForKey:@"course_price"];
    cell.cover.image=[UIImage imageNamed:[course objectForKey:@"course_cover_image"]];
    
    //cell.review.image=[UIImage imageNamed:[course objectForKey:@"1star.png"]];
    
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
                
                
                [self.imageCache setObject:img forKey:imageUrlString];
                
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    CollectionCellContent *updateCell = (CollectionCellContent*)[self.ipadcollection cellForItemAtIndexPath:indexPath];
                    if (updateCell) {
                        
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
- (void)searchaction:(id)sender
{
    [self performSegueWithIdentifier:@"CourseSearch" sender:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)menulistener:(id)sender {
    
    
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Showmenu" object:nil];
}
- (IBAction)course_type:(UISegmentedControl*)sender {
    [course_type setSegmentedControlStyle:UISegmentedControlStylePlain];
    if (sender.selectedSegmentIndex==0) {
        
        course_type_val=@"All";
        offset=0;
        loadcompleted=0;
        [courselist removeAllObjects];
        [_imageOperationQueue cancelAllOperations];
        self.ipadcollection.hidden=NO;
        
        
        [self loadDatas];
        
        
    }
    else  if (sender.selectedSegmentIndex==1) {
        course_type_val=@"Free";
        offset_free=0;
        loadcompleted=0;
        [courselist removeAllObjects];
        [_imageOperationQueue cancelAllOperations];
        self.ipadcollection.hidden=NO;
        
        [self loadDatas];
        
    }
    else  if (sender.selectedSegmentIndex==2) {
        course_type_val=@"Paid";
        offset_paid=0;
        loadcompleted=0;
        [courselist removeAllObjects];
        self.ipadcollection.hidden=NO;
        [_imageOperationQueue cancelAllOperations];
        
        [self loadDatas];
        
    }
    else  if (sender.selectedSegmentIndex==3) {
        
//        offset_paid=0;
//        loadcompleted=0;
//        [courselist removeAllObjects];
        [_imageOperationQueue cancelAllOperations];
          UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"Dashboard_iPad" bundle:nil];
        categorypopoverViewController *testViewController =[welcome instantiateViewControllerWithIdentifier:@"CategoryPopover"];
        userDataPopover = [[UIPopoverController alloc] initWithContentViewController:testViewController];
        userDataPopover.popoverContentSize = CGSizeMake(320.0, 400.0);
        CGRect newFrame=[(UIButton*)sender frame];
        NSLog(@"%@", NSStringFromCGRect(newFrame));
        newFrame.origin.x=475;
        newFrame.origin.y=30;
        [userDataPopover presentPopoverFromRect:newFrame
                                         inView:self.view
                       permittedArrowDirections:UIPopoverArrowDirectionUp
                                       animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(categorylistener:)   name:@"Categorylist"   object:nil];
        
        
    }
    
    
    
}

- (void)categorylistener:(id)sender
{
    categoryname=[sender valueForKey:@"object"];
    NSLog(@"catergory name %@",categoryname);
    [userDataPopover dismissPopoverAnimated:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Categorylist" object:nil];
    [self performSegueWithIdentifier:@"CourseDatas" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"CourseDatas"]) {
        
        CategorywiseDatasiPadViewController *vc=[segue destinationViewController];
        vc.categoryname=categoryname;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
-(void)dealloc
{
    [super dealloc];
    HUD.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Categorylist" object:nil];
}

@end
