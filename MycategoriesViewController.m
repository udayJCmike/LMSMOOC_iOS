//
//  MycategoriesViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 18/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//
#import "MBProgressHUD.h"
#import "MycategoriesViewController.h"
#import "databaseurl.h"
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_35 (SCREEN_HEIGHT == 480)
#define SCREEN_40 (SCREEN_HEIGHT == 568)
@interface MycategoriesViewController ()
{
    databaseurl *du;
}
@end

@implementation MycategoriesViewController
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SCREEN_35) {
        for (NSLayoutConstraint *con in self.view.constraints)
        {
            if (con.firstItem == self.category_tableView && con.firstAttribute == NSLayoutAttributeTop) {
               
                self.tableheightConstraint.constant = 480;
                [self.category_tableView needsUpdateConstraints];
                
                
            }
        }
    }
    loadcompleted=0;
    category_tableView.dataSource=self;
    category_tableView.delegate=self;
     categorylist=[[NSMutableArray alloc]init];
  
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menulistener:) name:@"Showmenu" object:nil];
    
    
    
   // UIButton *button1 =  [UIButton buttonWithType:UIButtonTypeCustom];
  //  [button1 setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    //[button setTitle:@"Add Categories" forState:UIControlStateNormal];
   // [button1 addTarget:self action:@selector(addCategories) forControlEvents:UIControlEventTouchUpInside];
   // [button1 setFrame:CGRectMake(200, 0, 100, 32)];
   // [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  //  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    du=[[databaseurl alloc]init];
   [self loadDatas];
    [category_tableView reloadData];
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
        
        [self performSelector:@selector(getList) withObject:self afterDelay:0.2f];
        
        
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


- (IBAction)addcategory:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(additemslistener:) name:@"Addcategories" object:nil];
     [self performSegueWithIdentifier:@"addcategories" sender:self];
}


//Method removed edited by Uday
//-(void)addCategories
//{
  //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(additemslistener:) name:@"Addcategories" object:nil];
  //  [self performSegueWithIdentifier:@"addcategories" sender:self];
//}

- (void)additemslistener:(id)sender {
   // NSLog(@"selected list in receiver sdie %@",[sender valueForKey:@"object"]);
    NSArray *list=[sender valueForKey:@"object"];
    [categorylist addObjectsFromArray:list];
       [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Addcategories" object:nil];
    [self.category_tableView reloadData];
}

- (void)menulistener:(id)sender {
    
    
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Showmenu" object:nil];
}
-(void)getList
{
    studentid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
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
        NSArray *Listofdatas=[menu objectForKey:@"Category List"];
        
     //   NSLog(@"listof datas values %@",Listofdatas);
      
        if ([Listofdatas count]>0)
        {
            
            
            for (id list in Listofdatas)
            {
                NSDictionary *arrayList1=[(NSDictionary*)list objectForKey:@"serviceresponse"];
                [categorylist addObject:[arrayList1 objectForKey:@"category_name"]];
                
            }
           // NSLog(@"category values %@",categorylist);
        }
        else
        {
            loadcompleted=1;
        }
        
        if (![HUD isHidden]) {
            [HUD hide:YES];
        }
        
        [self performSelector:@selector(relodtable) withObject:self afterDelay:0.5f];
        
    }
    
}
-(void)relodtable
{
    [category_tableView reloadData];
}
-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Categories.php?service=MyCategorylist";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&%@=%@",firstEntity,value1,secondEntity,value2];
    NSURL *url = [NSURL URLWithString:url2];
    NSLog(@"%@ url %@ post",url2 ,post    );
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categorylist count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *simpleTableIdentifier = @"mycourses";
    
    cell = [self.category_tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [categorylist objectAtIndex:indexPath.row];
  //  NSLog(@"category data %@", cell.textLabel.text);
    return cell;
}





// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(RemoveStatus:)
                                                 name:@"RemoveStatus"
                                               object:nil];
    [self performSegueWithIdentifier:@"Mycategory" sender:self];
}

-(void)RemoveStatus:(id)sender
{
    NSString *status=  [sender valueForKey:@"object"];
    if ([status isEqualToString:@"success"])
    {
        NSIndexPath *index=[self.category_tableView indexPathForSelectedRow];
        [categorylist removeObjectAtIndex:index.row];
        [self.category_tableView reloadData];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoveStatus" object:nil];
    
}
/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"Mycategory"]) {
        NSIndexPath *index=[self.category_tableView indexPathForSelectedRow];
        MycategoriesDetailViewController *vc=[segue destinationViewController];
        vc.categoryname=[categorylist objectAtIndex:index.row];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
-(void)dealloc
{
    [super dealloc];
    HUD.delegate = nil;
}
@end
