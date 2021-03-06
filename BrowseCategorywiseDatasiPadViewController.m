//
//  BrowseCategorywiseDatasiPadViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 20/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "BrowseCategorywiseDatasiPadViewController.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface BrowseCategorywiseDatasiPadViewController ()

@end

@implementation BrowseCategorywiseDatasiPadViewController


@synthesize categoryname;
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
 
   // NSLog(@"catergory name received %@",categoryname);
    self.navigationItem.title=categoryname;
    offset=0;
    loadcompleted=0;
    courselist=[[NSMutableArray alloc]init];
    du=[[databaseurl alloc]init];
    delegate=AppDelegate;
    
    _imageOperationQueue = [[NSOperationQueue alloc]init];
    _imageOperationQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [[NSCache alloc] init];
    [self loadDatas];
}
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
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    offset=0;
    loadcompleted=0;
    [courselist removeAllObjects];
    [_imageOperationQueue cancelAllOperations];
    
}
-(void)getCourseList
{
    
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"BrowseCategorywiseDatas.php";
   
    NSString *URLString=[NSString stringWithFormat:@"%@%@?offset=%d&category=%@",urltemp,url1,offset,categoryname];
    
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
            NSString* mess=[temp objectForKey:@"course_description"];
            mess = [mess stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
            mess = [mess stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
            [temp setValue:mess forKey:@"course_description"];

            [courselist addObject:temp];
            
            
        }
        
        
        
    }
    else
    {
     if ((loadcompleted==0)&&([courselist count]==0))  {
            [self ShowAlert:@"No data found." title:@"Info"];
            
        }
        loadcompleted=1;
       // NSLog(@"No Data found");
    }
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    offset+=[courselist count];
    
    
    [self performSelector:@selector(reloaddatas) withObject:nil afterDelay:1.0f];
    
    
}
-(void)ShowAlert:(NSString*)message title:(NSString *)title
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
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
    cell.price.text=[NSString stringWithFormat:@"$ %@",[course objectForKey:@"course_price"]];
    cell.numberofpurchased.text=[NSString stringWithFormat:@"%@ students",[course objectForKey:@"numofpurchased"]];
    cell.cover.image=[UIImage imageNamed:[course objectForKey:@"course_cover_image"]];
    NSString *promo=[course objectForKey:@"promocode_available"];
    if ([promo isEqualToString:@"1"]) {
        cell.promoimage.hidden=NO;
    }
    else
    {
       cell.promoimage.hidden=YES;
    }

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    HUD.delegate = nil;
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadDatas) object:self];
}

@end
