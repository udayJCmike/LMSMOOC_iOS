//
//  MailinboxTableViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "MailinboxTableViewController.h"
#import "lmsmoocAppDelegate.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface MailinboxTableViewController ()
{
    databaseurl *du;
}
@end

@implementation MailinboxTableViewController

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
    du=[[databaseurl alloc]init];
    unread=0;
    count=0;
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
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
    [self loadDatas];
    
    self.navigationItem.title=[NSString stringWithFormat:@"Inbox (%d/%d)",unread,count];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    self.navigationItem.title=[NSString stringWithFormat:@"Inbox (%d/%d)",unread,count];
}
-(void)loadDatas
{
    if ([[du submitvalues]isEqualToString:@"Success"])
    {
        [self getMailList];
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
-(void)getMailList
{
   
    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Inboxlist.php?";
    __block NSString *mess;
    
    NSString *URLString=[NSString stringWithFormat:@"%@%@studentid=%@",urltemp,url1,userid];
    
    NSMutableArray *search = [du MultipleCharacters:URLString];
    
    NSDictionary* menu = [search valueForKey:@"serviceresponse"];
    
    NSArray *Listofdatas=[menu objectForKey:@"Inbox List"];
    
    
    if ([Listofdatas count]>0)
    {
        inbox=[[NSMutableArray alloc]init];
        count=(int)[Listofdatas count];
        
        for (int i=0;i<[Listofdatas count];i++)
        {
            NSDictionary *arrayList1= [Listofdatas objectAtIndex:i];
            NSDictionary *temp=[arrayList1 objectForKey:@"serviceresponse"];
            NSLog(@"%@",[temp objectForKey:@"inbox_id"]);
            if([[temp objectForKey:@"read_status"]isEqualToString:@"0"])
            {
                unread++;
            }
            mess=[temp objectForKey:@"inboxmessage"];
            mess = [mess stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n\n"];
            mess = [mess stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n\n"];
            [temp setValue:mess forKey:@"inboxmessage"];
            [inbox addObject:temp];
            
            
        }
        [self.tableView reloadData];
       
    }
    
     [HUD hide:YES];
    
    

    
}

-(void)checkdata
{
    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
//    NSLog(@"userid %@",userid);
    NSString *response=[self HttpPostEntityFirst1:@"studentid" ForValue1:userid  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
    NSError *error;
    NSString *jsonstring = [response stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    jsonstring = [jsonstring stringByReplacingOccurrencesOfString: @"<br>" withString: @""];
    jsonstring = [jsonstring stringByReplacingOccurrencesOfString: @"<hr>" withString: @""];
    jsonstring = [jsonstring stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *parsedvalue = [json objectWithString:jsonstring error:&error];
    
   // NSLog(@"%@ parsedvalue",parsedvalue);
    if (parsedvalue == nil)
    {
        
        //NSLog(@"parsedvalue == nil");
        
    }
    else
    {
          NSDictionary* menu = [parsedvalue objectForKey:@"serviceresponse"];
        NSArray *Listofdatas=[menu objectForKey:@"Inbox List"];
        
    //  NSLog(@"listof datas values %@",Listofdatas);
        
        if ([Listofdatas count]>0)
        {
            inbox=[[NSMutableArray alloc]init];
            
            for (id list in Listofdatas)
            {
                NSDictionary *arrayList1=[(NSDictionary*)list objectForKey:@"serviceresponse"];
                [inbox addObject:arrayList1];
                
            }
        }
        
        [HUD hide:YES];
        
       // NSLog(@"list values %@",inbox);
    
    }
    if (![HUD isHidden]) {
        [HUD hide:YES];
    }
    
    
}
-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Inboxlist.php?";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&%@=%@",firstEntity,value1,secondEntity,value2];
    NSURL *url = [NSURL URLWithString:url2];
    
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
    return [inbox count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAILinboxTableViewCell *cell =(MAILinboxTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"mailinbox" forIndexPath:indexPath];
    
    NSDictionary *temp=[inbox objectAtIndex:indexPath.row];
   
    

    cell.Subject.text=[temp objectForKey:@"subject"];
     cell.date.text=[temp objectForKey:@"sent_date"];
   
    if ([[temp objectForKey:@"important_status"]isEqualToString:@"1"]) {
          cell.importantstatus.image=[UIImage imageNamed:@"important.png"];
    }
    else
    {
     cell.importantstatus.image=[UIImage imageNamed:@"unimportant.png"];   
    }
    NSString *read=  [[inbox objectAtIndex:indexPath.row] objectForKey:@"read_status"];
    if ([read isEqualToString:@"0"]) {
        cell.backgroundColor= [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0f];
    }
    else
    {
        cell.backgroundColor=[UIColor clearColor];
    }
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
    [self updatereadStatus:[inbox objectAtIndex:indexPath.row]];
    if ([[[inbox objectAtIndex:indexPath.row] objectForKey:@"read_status"]isEqualToString:@"0"]) {
        unread--;
    }

    NSLog(@"read %@",[[inbox objectAtIndex:indexPath.row] objectForKey:@"read_status"]);
  NSMutableDictionary *dict=[inbox objectAtIndex:indexPath.row];
    [dict setValue:@"1" forKey:@"read_status"];
    [inbox replaceObjectAtIndex:indexPath.row withObject:dict];
  //   NSLog(@"read %@",[[inbox objectAtIndex:indexPath.row] objectForKey:@"read_status"]);
    [self performSegueWithIdentifier:@"DetailView" sender:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importantStatus:) name:@"importantStatus" object:nil];
    
}


-(void)updatereadStatus:(NSDictionary*)selectedrow
{
   dispatch_group_t imageQueue = dispatch_group_create();
    
    dispatch_group_async(imageQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                         ^{
                             NSLog(@"read updad1 %@",[selectedrow objectForKey:@"read_status"]);
                             
//                             if([[selectedrow objectForKey:@"read_status"]isEqualToString:@"0"])
//                             {
//                                 NSLog(@"read updad2");
                                 [self updatereadstate:[selectedrow objectForKey:@"inbox_id"]];
                                 
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadStatus"
                                                                                     object:self
                                                                                   userInfo:nil];
//                             }
//                             
                            
                             
                             
                             
                             
                             
                             //                             dispatch_async(dispatch_get_main_queue(), ^{
                             //
                             //                             });
                             
                             
                         });
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ReadStatus:)
                                                 name:@"ReadStatus"
                                               object:nil];
    
    
}
-(void)ReadStatus:(id)sender
{
    
    NSLog(@"ReadStatus updated");
   
}
-(void)importantStatus:(id)sender
{
     //  NSLog(@"Important status %@ updated",sender);
    NSIndexPath *indexpath=[self.tableView indexPathForSelectedRow];
    [[inbox objectAtIndex:indexpath.row] setObject:[sender valueForKey:@"object"] forKey:@"important_status"];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"DetailView"]) {
        NSIndexPath *indexpath=[self.tableView indexPathForSelectedRow];
        MailDetailsViewController *vc=[segue destinationViewController];
        vc.selectedrow=[inbox objectAtIndex:indexpath.row];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
-(void)updatereadstate:(NSString *)inboxid
{
    
    NSString *response=[self HttpPostEntityFirst2:@"inboxid" ForValue1:inboxid EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
    
    NSError *error;
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *parsedvalue = [json objectWithString:response error:&error];
    
    //  NSLog(@"%@ parsed valued",parsedvalue);
    if (parsedvalue == nil)
    {
        //NSLog(@"parsedvalue == nil");
       
    }
    else
    {
        
        NSDictionary* menu = [parsedvalue objectForKey:@"serviceresponse"];
        if ([[menu objectForKey:@"servicename"] isEqualToString:@"Inbox Data"])
        {
            if ([[menu objectForKey:@"success"] isEqualToString:@"Yes"])
            {
                
                NSLog(@"Inserting  Succecssful");
                
                            }
            else if ([[menu objectForKey:@"success"] isEqualToString:@"No"])
                
            {
                                   NSLog(@"insertion failed");
                
            }
            
        }
    }
    
}
-(NSString *)HttpPostEntityFirst2:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Inbox.php?service=inboxreadstatus";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&studentid=%@&%@=%@",firstEntity,value1,[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],secondEntity,value2];
    // NSLog(@"POST %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    return [du returndbresult:post URL:url];
}

-(void)dealloc{
    [super dealloc];
      [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReadStatus" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"importantStatus" object:nil];
}
@end
