//
//  lmsmoocViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 9/9/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "lmsmoocViewController.h"
#import "PageContentViewController.h"
@interface lmsmoocViewController ()
{
    NSArray *viewControllers;
    UIPageControl *pageControl;
}
@end

@implementation lmsmoocViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
          _pageImages = @[@"ban1.png", @"ban2.png", @"ban3.png", @"ban4.png",@"ban5.png"];
    }
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
          _pageImages = @[@"bantab1.png", @"bantab2.png", @"bantab3.png", @"bantab4.png", @"bantab5.png"];
    }
  
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Ready to start!" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [button addTarget:self action:@selector(showinfo) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(50, 0, 150, 30)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIImageView *imagevc=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 75, 32)];
    imagevc.image=[UIImage imageNamed:@"logo.png"];
    [imagevc setFrame:CGRectMake(0, 0, 100, 30)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:imagevc];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate=self;
    [[self.pageViewController view] setFrame:CGRectMake(0, 0, [[self view] bounds].size.width, [[self view] bounds].size.height)];
    [[self.pageViewController view]setBackgroundColor:[UIColor whiteColor]];
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
   

    viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    //self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 20);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
   // [self.view bringSubviewToFront:_pageViewController.view];
   
 
}
-(void)barbutton:(NSUInteger)index
{
    NSLog(@"index value %d",index);
    
    if(index==5)
    {
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Explore Courses!" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button addTarget:self action:@selector(showcourse) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(50, 0, 150, 30)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    else  {
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Ready to start!" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button addTarget:self action:@selector(showinfo) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(50, 0, 150, 30)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
    }

}

-(void)showinfo
{
    PageContentViewController *startingViewController = [self viewControllerAtIndex:4];
    
    
    viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    NSArray *subviews = self.pageViewController.view.subviews;
    UIPageControl *thisControl = nil;
    for (int i=0; i<[subviews count]; i++) {
        if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]]) {
            thisControl = (UIPageControl *)[subviews objectAtIndex:i];
            thisControl.currentPage=4;
        }
    }
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Explore Courses!" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [button addTarget:self action:@selector(showcourse) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(50, 0, 150, 30)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
 

}
-(void)showcourse
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"BrowseCourses_iPad" bundle:nil];
        UIViewController *initialvc=[welcome instantiateInitialViewController];
        [self.navigationController pushViewController:initialvc animated:YES];
        //    initialvc.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        //    [self presentModalViewController:initialvc animated:YES];
    }
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"BrowseCourses" bundle:nil];
        UIViewController *initialvc=[welcome instantiateInitialViewController];
        [self.navigationController pushViewController:initialvc animated:YES];
        //    initialvc.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        //    [self presentModalViewController:initialvc animated:YES];
    }

}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    
           // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
//    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
   
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
   
    index--;
     [self barbutton:index];
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageImages count]) {
         [self barbutton:index];
        return nil;
    }
    else{
         [self barbutton:index];
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.hidden == YES)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

@end
/*@implementation UIPageViewController (Additions)

- (void)setViewControllers:(NSArray *)viewControllers direction:(UIPageViewControllerNavigationDirection)direction invalidateCache:(BOOL)invalidateCache animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    NSArray *vcs = viewControllers;
    __weak UIPageViewController *mySelf = self;
    
    if (invalidateCache && self.transitionStyle == UIPageViewControllerTransitionStyleScroll) {
        UIViewController *neighborViewController = (direction == UIPageViewControllerNavigationDirectionForward
                                                    ? [self.dataSource pageViewController:self viewControllerBeforeViewController:viewControllers[0]]
                                                    : [self.dataSource pageViewController:self viewControllerAfterViewController:viewControllers[0]]);
        [self setViewControllers:@[neighborViewController] direction:direction animated:NO completion:^(BOOL finished) {
            [mySelf setViewControllers:vcs direction:direction animated:animated completion:completion];
        }];
    }
    else {
        [mySelf setViewControllers:vcs direction:direction animated:animated completion:completion];
    }
}

@end*/
