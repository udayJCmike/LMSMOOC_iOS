//
//  Myfavorites_iPadViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "Myfavorites_iPadViewController.h"

@interface Myfavorites_iPadViewController ()

@end

@implementation Myfavorites_iPadViewController

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
    // if Navigation Bar is already hidden
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
    offset=0;
    loadcompleted=0;
    courselist=[[NSMutableArray alloc]init];
    du=[[databaseurl alloc]init];
    delegate=AppDelegate;
    
    _imageOperationQueue = [[NSOperationQueue alloc]init];
    _imageOperationQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [[NSCache alloc] init];
    
    [self loadDatas];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(activateDeletionMode:)];
    longPress.delegate = self;
    [self.ipadcollection addGestureRecognizer:longPress];
}
#pragma mark - gesture-recognition action methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self.ipadcollection];
    deleteatindexPath = [self.ipadcollection indexPathForItemAtPoint:touchPoint];
    if (deleteatindexPath && [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        return NO;
    }
    return YES;
}

- (void)activateDeletionMode:(UILongPressGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan)
    {
        deleteatindexPath = [self.ipadcollection indexPathForItemAtPoint:[gr locationInView:self.ipadcollection]];
        if (deleteatindexPath)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Remove from favorites" message:@"Would you like to remove the course from favorites?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        removeitem_courseid=[[courselist objectAtIndex:deleteatindexPath.row] objectForKey:@"course_id"];
        NSLog(@"remove courseid=%@",removeitem_courseid);
        [[NSUserDefaults standardUserDefaults]setValue:removeitem_courseid forKey:@"removeitemcourseid"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [courselist removeObjectAtIndex:deleteatindexPath.row];
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"Please wait...";
        [HUD show:YES];
        [self performSelector:@selector(removeCourse) withObject:self afterDelay:0.1f];
        [self.ipadcollection reloadData];
        
    }
}

- (void)menulistener:(id)sender {
    
    
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Showmenu" object:nil];
}
-(void)ShowAlert:(NSString*)message title:(NSString *)title
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
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
    
    du=[[databaseurl alloc]init];
    
    NSString*  studentid= [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    
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
        if ((loadcompleted==0)&&([courselist count]==0))  {
            [self ShowAlert:@"No data found." title:@"Info"];
            
        }
        loadcompleted=1;
        NSLog(@"No Datas found");
    }
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    offset+=[courselist count];
    
    
    [self performSelector:@selector(reloaddatas) withObject:nil afterDelay:1.0f];
    
    
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
    NSLog(@"clicked at index %d",indexPath.row);
    NSDictionary *temp=[courselist objectAtIndex:indexPath.row];
    if([[temp objectForKey:@"studentenrolled"]isEqualToString:@"0"])
    {
          NSString *url=[NSString stringWithFormat:@"%@?course_id=%@&authorid=%@&pur=%@&catcourse=&coursetype=",delegate.course_detail_url,[temp objectForKey:@"course_id"], [temp objectForKey:@"instructor_id"],[temp objectForKey:@"numofpurchased"]];
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


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CourseList";
    
    
    CollectionCellContent *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSDictionary *course;
    course=[courselist objectAtIndex:indexPath.row];
    cell.coursename.text=[course objectForKey:@"course_name"];
    cell.authorname.text=[course objectForKey:@"course_author"];
    cell.price.text=[NSString stringWithFormat:@"$ %@",[course objectForKey:@"course_price"]];
    cell.numberofpurchased.text=[NSString stringWithFormat:@"%@ students",[course objectForKey:@"numofpurchased"]];
    cell.cover.image=[UIImage imageNamed:[course objectForKey:@"course_cover_image"]];
    //cell.review.image=[UIImage imageNamed:[course objectForKey:@"ratings"]];
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
    NSString *enroll=[course objectForKey:@"studentenrolled"];
    if ([enroll isEqualToString:@"1"]) {
        cell.enrolled.hidden=NO;
    }
    else
    {
        cell.enrolled.hidden=YES;
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

- (void)removeCourse {
    
   
    
    
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
    NSString *url1=@"Myfavorites_remove.php?service=RemoveCourse";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
//   NSLog(@"in psot method %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"removeitemcourseid"]);
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&courseid=%@&%@=%@",firstEntity,value1,[[NSUserDefaults standardUserDefaults]valueForKey:@"removeitemcourseid"],secondEntity,value2];
   //    NSLog(@"in psot method %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    
    return [du returndbresult:post URL:url];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [super dealloc];
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadDatas) object:self];
    HUD.delegate = nil;
}
@end
