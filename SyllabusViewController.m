//
//  SyllabusViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 22/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "SyllabusViewController.h"

@interface SyllabusViewController ()

@end

@implementation SyllabusViewController
@synthesize SyllabustableView;

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
    sectionTitleArray=[[NSMutableArray alloc]init];
    arrayForBool=[[NSMutableArray alloc]init];
    sectionContentDict=[[NSMutableDictionary alloc]init];   
    syllabus_details=[[NSMutableDictionary alloc]init];
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
         
        NSString*courseid= [delegate.CourseDetail objectForKey:@"course_id"];
        
        NSString *urltemp=[[databaseurl sharedInstance]DBurl];
        NSString *url1=@"DetailCourses.php";
        
        NSString *URLString=[NSString stringWithFormat:@"%@%@?courseid=%@",urltemp,url1,courseid];
        
        NSMutableArray *search = [du MultipleCharacters:URLString];
        
        NSArray* menu = [search valueForKey:@"JsonOutput"];
        
        
       
        
        
        if ([menu count]>0)
        {
            
            
            for (int i=0;i<[menu count];i++)
            {
                NSDictionary *arrayList1= [menu objectAtIndex:i];
                [sectionTitleArray addObject:[arrayList1 objectForKey:@"ParentCategory"]];
                NSMutableArray *temp2=[[NSMutableArray alloc]init];
                NSArray *temp=[arrayList1 objectForKey:@"ChildCategory"];
                for (int j=0; j<[temp count]; j++) {
                   [temp2 addObject:[[temp objectAtIndex:j]valueForKey:@"name_lecture"]];
                }
             
                
                [syllabus_details setValue:temp forKey:[arrayList1 objectForKey:@"ParentCategory"]];
                [sectionContentDict setValue:temp2 forKey:[arrayList1 objectForKey:@"ParentCategory"]];
                [arrayForBool insertObject:[NSNumber numberWithBool:NO] atIndex:i];
                               
                
            }
            
            
        }
        else
        {
            
            NSLog(@"No Datas found");
        }
//        NSLog(@"section title array %@",sectionTitleArray);
   //      NSLog(@"section content array %@",sectionContentDict);
//         NSLog(@"section bool array %@",arrayForBool);
        
        [self.SyllabustableView reloadData];
        if (![HUD isHidden]) {
            [HUD hide:YES];
        }
            
        
        
        
        
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  //  NSLog(@"[sectionTitleArray count] %lu",(unsigned long)[sectionTitleArray count]);
    return [sectionTitleArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        return [[sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:section]] count];
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor whiteColor];
    UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 50)];
    BOOL manyCells                  = [[arrayForBool objectAtIndex:section] boolValue];
    if (!manyCells) {
        headerString.text =[sectionTitleArray objectAtIndex:section];
    }else{
        headerString.text =[sectionTitleArray objectAtIndex:section];
    }
    headerString.textAlignment      = NSTextAlignmentLeft;
    headerString.textColor          = [UIColor blackColor];
    [headerView addSubview:headerString];
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [headerView addGestureRecognizer:headerTapped];
    
    //up or down arrow depending on the bool
    UIImageView *upDownArrow        = [[UIImageView alloc] initWithImage:manyCells ? [UIImage imageNamed:@"upArrowBlack"] : [UIImage imageNamed:@"downArrowBlack"]];
    upDownArrow.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        upDownArrow.frame               = CGRectMake(self.view.frame.size.width-100, 10, 30, 30);
    }
    else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        upDownArrow.frame               = CGRectMake(self.view.frame.size.width-40, 10, 30, 30);
    }
   
    
    [headerView addSubview:upDownArrow];
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer  = [[UIView alloc] initWithFrame:CGRectZero];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        return 60;
    }
    else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        return 40;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
            return 60;
        }
    }
    else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
            return 40;
        }
    }
    
    return 1;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *CellIdentifier = @"ChildIdentifier";
    SyllabusLectureTableViewCell *cell = (SyllabusLectureTableViewCell*)[SyllabustableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[SyllabusLectureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
   cell.lecturetype.image=[UIImage imageNamed:nil];
    
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    if (!manyCells)
    {
        cell.textLabel.text=@"";
  cell.lecturetype.image=[UIImage imageNamed:nil];

    }
    else
    {
       
       cell.textLabel.text=@"";
        NSDictionary *selectedrow=[[syllabus_details valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        NSString *typename=[selectedrow valueForKey:@"type_lecture"];
        NSArray *content = [sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
        cell.textLabel.text = [content objectAtIndex:indexPath.row];
        cell.lecturetype.image=[UIImage imageNamed:[self setimage:typename]];
    }
   
    
    
    return cell;
}
-(NSString*)setimage:(NSString*)typename
{
    if ([typename isEqualToString:@"Text"]) {
       return @"text.png";
    }
    else if ([typename isEqualToString:@"Audio"]) {
        return @"audio.png";
    }
    else if ([typename isEqualToString:@"Video"]) {
       return @"video.png";
    }
    return @"text.png";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.SyllabustableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *selectedrow=[[syllabus_details valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    delegate.lectureDetail=[selectedrow mutableCopy];
    
    NSString *typename=[selectedrow valueForKey:@"type_lecture"];
    if ([typename isEqualToString:@"Text"])
    {
        [self sendNavigation:@"TextViewer"];
    }
    else if ([typename isEqualToString:@"Audio"])
    {
        [self sendNavigation:@"AudioPlayer"];
    }
    else if ([typename isEqualToString:@"Video"])
    {
        [self sendNavigation:@"VideoPlayer"];
    }
 //NSLog(@"%@",[sectionTitleArray objectAtIndex:indexPath.section]);
// NSLog(@"%@",[[syllabus_details valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] );
    
    
}

-(void)sendNavigation:(NSString*)identifiername
{
   if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        UIViewController *initialvc=[self.storyboard instantiateViewControllerWithIdentifier:identifiername];
        [self.navigationController pushViewController:initialvc animated:YES];
    }
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        
        UIViewController *initialvc=[self.storyboard instantiateViewControllerWithIdentifier:identifiername];
        [self.navigationController pushViewController:initialvc animated:YES];
        
    }
   
   // [self performSegueWithIdentifier:identifiername sender:self];
}
#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
//        if(![SyllabustableView.indexPathsForVisibleRows containsObject:indexPath])
//        {
            BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
            collapsed       = !collapsed;
            [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
            
            //reload specific section animated
            NSRange range   = NSMakeRange(indexPath.section, 1);
            NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.SyllabustableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
//        }
      
    }
}

- (void)dealloc {

    [super dealloc];
}
@end
