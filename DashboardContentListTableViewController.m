//
//  DashboardContentListTableViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "DashboardContentListTableViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "lmsmoocAppDelegate.h"
#import "HelpViewController.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface DashboardContentListTableViewController ()
{
    NSArray *titles;
    lmsmoocAppDelegate *delegate;
}
@end

@implementation DashboardContentListTableViewController

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
    delegate=AppDelegate;

    if (!delegate.profileimage)
    {
         NSLog(@"avatar URL not found");
        delegate.profileimage=[UIImage imageNamed:@"defaultprofile.png"];
        delegate.av_image=[NSString stringWithFormat:@"defaultprofile.png"];
    }
    else
    {
//        profileimage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:delegate.av_image]]];

    }
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.allowsSelection=YES;
       titles = [[NSArray alloc]initWithObjects:@"Home", @"Profile",@"Change Password", @"Inbox",@"My Courses",@"My Favorites",@"My Categories",@"My Authors",@"My Billing",@"About",@"Help",@"Logout",nil];
   // NSLog(@"did load called in tablelist");

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = delegate.profileimage;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"firstname"];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [imageView setNeedsDisplay];
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });

    // NSLog(@"view will appear in tablelist");
    
}
-(void)reloadTableContent
{
    [self viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  colorWithRed:66 green:139 blue:202 alpha:0.0
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}
//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   
////   UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
////    cell.backgroundColor= [UIColor colorWithRed:66/255.0f green:139/255.0f blue:202/255.0f alpha:1.0f];
//
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    
        return nil;
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
//    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
//    label.text = @"Friends Online";
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [label sizeToFit];
//    [view addSubview:label];
//    
//    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
   
        return 0;
    
    
}
//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
-(void)clearrows
{
    for (int i=0;i<[titles count];i++) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0 ];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor= [UIColor clearColor];
       [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self clearrows];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor= [UIColor colorWithRed:66/255.0f green:139/255.0f blue:202/255.0f alpha:1.0f];
    DashboardMainViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        courselist_iPhoneTableViewController *secondViewController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseList"];
        navigationController.viewControllers = @[secondViewController1];
    }
    else if(indexPath.section == 0 && indexPath.row == 1) {
        
        ProfileUpdateViewController *secondViewController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Profile"];
        navigationController.viewControllers = @[secondViewController1];
    }
    else if(indexPath.section == 0 && indexPath.row == 2) {
        
        ChangePasswordViewController *secondViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
        navigationController.viewControllers = @[secondViewController2];
    }
    else if(indexPath.section == 0 && indexPath.row == 3) {
        
        MailinboxTableViewController *secondViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"mailinbox"];
        navigationController.viewControllers = @[secondViewController2];
    }
    else if(indexPath.section == 0 && indexPath.row == 4) {
        
        MycoursesViewController *secondViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"mycourse"];
        navigationController.viewControllers = @[secondViewController2];
    }
    else if(indexPath.section == 0 && indexPath.row == 5) {
        
        MyfavoritesViewController *secondViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"myfavorites"];
        navigationController.viewControllers = @[secondViewController2];
    }
    else if(indexPath.section == 0 && indexPath.row == 6) {
        
        MycategoriesViewController *secondViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"mycategories"];
        navigationController.viewControllers = @[secondViewController2];
    }
    else if(indexPath.section == 0 && indexPath.row == 7) {
        
        MyauthorsTableViewController *secondViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"myauthors"];
        navigationController.viewControllers = @[secondViewController2];
    }
    else if(indexPath.section == 0 && indexPath.row == 8) {
        
        BillingTableViewController *secondViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"Billing"];
        navigationController.viewControllers = @[secondViewController2];
    }
    else if(indexPath.section == 0 && indexPath.row == 9) {
        
        FacebookLikeViewDemoViewController *secondViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"About"];
        navigationController.viewControllers = @[secondViewController2];
    }
    else if(indexPath.section == 0 && indexPath.row == 10) {
        
        HelpViewController *secondViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpVC"];
        navigationController.viewControllers = @[secondViewController2];
    }
   
    
    else if(indexPath.section == 0 && indexPath.row == 11)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.frostedViewController hideMenuViewController];
        return;
        
    }
    
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
        return [titles count];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
  
 cell.textLabel.text = titles[indexPath.row];
    
    
    return cell;
}


@end
