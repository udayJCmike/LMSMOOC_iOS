//
//  categorypopoverViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 17/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "categorypopoverViewController.h"

@interface categorypopoverViewController ()
{
    databaseurl *du;
}
@end

@implementation categorypopoverViewController
@synthesize category_tableView;
@synthesize categorylist;
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
    du=[[databaseurl alloc]init];
   
    if ([[du submitvalues]isEqualToString:@"Success"])
    {
        
        [self performSelector:@selector(getList) withObject:self afterDelay:0.0f];
        
    }

   
    // Do any additional setup after loading the view.
}
-(void)getList
{
    NSString *response=[self HttpPostEntityFirst1:@"studentid" ForValue1:@"32"  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
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
            loadcompleted=1;
        }
        
        if (![HUD isHidden]) {
            [HUD hide:YES];
        }
        [category_tableView reloadData];
        // NSLog(@"list values %@",inbox);
        
    }
    
}
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
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    cell = [self.category_tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [categorylist objectAtIndex:indexPath.row];
    //  NSLog(@"category data %@", cell.textLabel.text);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Categorylist"
                                                        object:[categorylist objectAtIndex:indexPath.row]
                                                      userInfo:nil];
}
-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Categories.php?service=Categorylist";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&%@=%@",firstEntity,value1,secondEntity,value2];
    NSURL *url = [NSURL URLWithString:url2];
    NSLog(@"%@ url",url2     );
    return [du returndbresult:post URL:url];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
