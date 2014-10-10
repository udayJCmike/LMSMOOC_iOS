//
//  MyauthorcoursesiPadViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 19/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "MyauthorcoursesiPadViewController.h"

@interface MyauthorcoursesiPadViewController ()

@end

@implementation MyauthorcoursesiPadViewController
@synthesize authorname;
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
    
    _imageOperationQueue = [[NSOperationQueue alloc]init];
    _imageOperationQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [[NSCache alloc] init];
 //   NSLog(@"authorid received %@",authorid);
    //UIButton *button2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    //[button2 setTitle:@"Remove From favorites" forState:UIControlStateNormal];
    // [button2 setTitle:@"Add to favorites" forState:UIControlStateSelected];
    //[button2 addTarget:self action:@selector(removeAuthorname) forControlEvents:UIControlEventTouchUpInside];
    //[button2 setFrame:CGRectMake(0, 0, 180, 32)];
    //[button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
   
     self.navigationItem.title=authorname;
    [self loadDatas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Method removed by Uday
//-(void)removeAuthorname
//{
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];
//    HUD.delegate = self;
//    HUD.labelText = @"Please wait...";
//    [HUD show:YES];
//    
//    
//    NSString* studentid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
//    NSString *response=[self HttpPostEntityFirst1:@"studentid" ForValue1:studentid  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
//    NSError *error;
//    //  NSLog(@"response %@",response);
//    SBJSON *json = [[SBJSON new] autorelease];
//    NSDictionary *parsedvalue = [json objectWithString:response error:&error];
//    
//    // NSLog(@"%@ parsedvalue",parsedvalue);
//    if (parsedvalue == nil)
//    {
//        
//        //NSLog(@"parsedvalue == nil");
//        
//    }
//    else
//    {
//        NSDictionary* menu = [parsedvalue objectForKey:@"serviceresponse"];
//        if ([[menu objectForKey:@"success"]isEqualToString:@"Yes"]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveStatus"
//                                                                object:@"success"
//                                                              userInfo:nil];
//        }
//        else
//        {
//            NSLog(@"failure");
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveStatus"
//                                                                object:@"failure"
//                                                              userInfo:nil];
//        }
//        
//    }
//    
//    [HUD hide:YES];
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    offset=0;
//    loadcompleted=0;
   // [courselist removeAllObjects];
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



-(void)ShowAlert:(NSString*)message title:(NSString *)title
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
}

// Do any additional setup after loading the view.

-(void)loadDatas
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
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

-(void)getCourseList
{
    
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"MyauthorDatas.php";
      NSString *  studentid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSString *URLString=[NSString stringWithFormat:@"%@%@?offset=%d&authorid=%@&studentid=%@",urltemp,url1,offset,authorid,studentid];
    
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
    offset+=10;
    
    
    [self performSelector:@selector(reloaddatas) withObject:nil afterDelay:1.0f];
    
    
}
- (IBAction)removeauthor:(id)sender {
    
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
    cell.price.text=[course objectForKey:@"course_price"];
    cell.cover.image=[UIImage imageNamed:[course objectForKey:@"course_cover_image"]];
    //cell.review.image=[UIImage imageNamed:[course objectForKey:@"ratings"]];
    NSString * rating =[course objectForKey:@"ratings"];
    
  ///  NSLog(@"rating %@",rating);
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
-(void)dealloc
{
    [super dealloc];
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadDatas) object:self];
    HUD.delegate = nil;
}
@end
