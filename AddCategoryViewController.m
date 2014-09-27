//
//  AddCategoryViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 27/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//
#import "MBProgressHUD.h"
#import "AddCategoryViewController.h"
#import "AddCategoriesTableViewCell.h"
@interface AddCategoryViewController ()
{
    databaseurl *du;
}
@end

@implementation AddCategoryViewController
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
    // Do any additional setup after loading the view.
    selectedimage=[UIImage imageNamed:@"checkBoxMarked.png"];
    unselectedimage=[UIImage imageNamed:@"checkBox.png"];
//  self.category_tableView.allowsMultipleSelection = YES;
    category_tableView.dataSource=self;
    category_tableView.delegate=self;
    categorylist=[[NSMutableArray alloc]init];
    selectedlist=[[NSMutableArray alloc]init];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
   // [button setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
    [button setTitle:@"Add to" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(menulistener:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0,150, 32)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
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


- (void)menulistener:(id)sender {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Addcategories"  object:selectedlist   userInfo:nil];
//    NSLog(@"seleted cell %@",selectedlist);
      NSString*  studentid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSString *response=[self HttpPostEntityFirstAdd:@"studentid" ForValue1:studentid  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
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
        if([[menu objectForKey:@"success"]isEqualToString:@"Yes"])
        
        {
//             NSLog(@"category inserted ");
        }
        else
        {
//           NSLog(@"category failed ");
        }
        
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    

   
}
-(void)getList
{
    
  NSString*  studentid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
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
            NSLog(@"No datas found");
        }
        
        
        if (![HUD isHidden]) {
            [HUD hide:YES];
        }
        [self performSelector:@selector(relodtable) withObject:self afterDelay:0.2f];
        
    }
    
}
-(void)relodtable
{
    [category_tableView reloadData];
}
-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Categories.php?service=ShowCategoryList";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&%@=%@",firstEntity,value1,secondEntity,value2];
    NSURL *url = [NSURL URLWithString:url2];
//    NSLog(@"%@ url %@ post",url2 ,post    );
    return [du returndbresult:post URL:url];
}
-(NSString *)HttpPostEntityFirstAdd:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    NSString *senditem=[NSString stringWithFormat:@"count=%lu",(unsigned long)[selectedlist count]];
    for (int i=0;i<[selectedlist count]; i++) {
        
        senditem=[NSString stringWithFormat:@"%@&%d=%@",senditem,i,[selectedlist objectAtIndex:i]];
    }
//      NSLog(@"seleted post %@",senditem);
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Categories.php?service=AddCategory";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&%@=%@&%@",firstEntity,value1,secondEntity,value2,senditem];
    NSURL *url = [NSURL URLWithString:url2];
//    NSLog(@"%@ url %@ post",url2 ,post    );
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
    AddCategoriesTableViewCell *cell;
    static NSString *simpleTableIdentifier = @"mycourses";
    
    cell = (AddCategoriesTableViewCell*)[self.category_tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[AddCategoriesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
      
        
    }
    
    cell.textLabel.text = [categorylist objectAtIndex:indexPath.row];
    cell.marked.image=unselectedimage;
   
   // cell.marked.image = ([selectedlist containsObject:[categorylist objectAtIndex:indexPath.row]]) ? selectedimage : unselectedimage;
    //  NSLog(@"category data %@", cell.textLabel.text);
    return cell;
}





// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![selectedlist containsObject:[categorylist objectAtIndex:indexPath.row]])
    {
        AddCategoriesTableViewCell *tableViewCell =(AddCategoriesTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
       
        tableViewCell.marked.image=selectedimage;
        [selectedlist addObject:[categorylist objectAtIndex:indexPath.row]];
    }
    else if([selectedlist containsObject:[categorylist objectAtIndex:indexPath.row]])
    {
        AddCategoriesTableViewCell *tableViewCell =(AddCategoriesTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
        
        tableViewCell.marked.image=unselectedimage;
        [selectedlist removeObject:[categorylist objectAtIndex:indexPath.row]];
    }
    
}







@end
