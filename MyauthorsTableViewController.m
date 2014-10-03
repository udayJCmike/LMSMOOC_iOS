//
//  MyauthorsTableViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "MyauthorsTableViewController.h"
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_35 (SCREEN_HEIGHT == 480)
#define SCREEN_40 (SCREEN_HEIGHT == 568)
@interface MyauthorsTableViewController ()

@end

@implementation MyauthorsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  

    
    myauthors=[[NSMutableArray alloc]init];
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
    du=[[databaseurl alloc]init];
    delegate=AppDelegate;
    
    [self loadDatas];

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
-(void)getList
{
  NSString *  studentid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSString *response=[self HttpPostEntityFirst1:@"studentid" ForValue1:studentid  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
    NSError *error;
   NSLog(@"response %@",response);
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
        NSArray *Listofdatas=[menu objectForKey:@"Author List"];
        
        //   NSLog(@"listof datas values %@",Listofdatas);
        
        if ([Listofdatas count]>0)
        {
            
            
            for (id list in Listofdatas)
            {
                NSDictionary *arrayList1=[(NSDictionary*)list objectForKey:@"serviceresponse"];
                
                [myauthors addObject:arrayList1];
                
            }
            // NSLog(@"category values %@",categorylist);
        }
        else
        {
            if ([myauthors count]==0)  {
                [self ShowAlert:@"No data found." title:@"Info"];
                
            }
        }
       
        [HUD hide:YES];
        [self performSelector:@selector(relodtable) withObject:self afterDelay:0.5f];
        
    }
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    
    
}
-(void)ShowAlert:(NSString*)message title:(NSString *)title
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
}
-(void)relodtable
{
    [self.tableView reloadData];
}
-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Myauthor.php?service=Myauthorlist";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&%@=%@",firstEntity,value1,secondEntity,value2];
    NSURL *url = [NSURL URLWithString:url2];
    NSLog(@"%@ url %@ post",url2 ,post    );
    return [du returndbresult:post URL:url];
}


- (void)menulistener:(id)sender {
    
    
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Showmenu" object:nil];
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

    // Return the number of rows in the section.
    return [myauthors count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AuthorTableViewCell *cell = (AuthorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"myauthors" forIndexPath:indexPath];
    
    NSDictionary *temp=[myauthors objectAtIndex:indexPath.row];
    cell.authorname.text=[temp valueForKey:@"course_author"];
      cell.noofpurchased.text=[temp valueForKey:@"no_course"];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(RemoveStatus:)
                                                 name:@"RemoveStatus"
                                               object:nil];
    [self performSegueWithIdentifier:@"MyAuthorDatas" sender:self];
}

-(void)RemoveStatus:(id)sender
{
    NSString *status=  [sender valueForKey:@"object"];
    if ([status isEqualToString:@"success"])
    {
        NSIndexPath *index=[self.tableView indexPathForSelectedRow];
        [myauthors removeObjectAtIndex:index.row];
        [self.tableView reloadData];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoveStatus" object:nil];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"MyAuthorDatas"]) {
        NSIndexPath *index=[self.tableView indexPathForSelectedRow];
        MyauthorcoursesViewController *vc=[segue destinationViewController];
        vc.authorid=[[myauthors objectAtIndex:index.row]objectForKey:@"instructor_id"];
        vc.authorname=[[myauthors objectAtIndex:index.row]objectForKey:@"course_author"];
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
