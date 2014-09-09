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
    NSArray *viewControllers;UIPageControl *pageControl;
}
@end

@implementation lmsmoocViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pageTitles = @[@"LMS MOOC 1", @"LMS MOOC 2", @"LMS MOOC 3", @"LMS MOOC 4"];
    _pageImages = @[@"page1.jpg", @"page2.jpg", @"page3.png", @"page4.jpg"];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];    
    [button setTitle:@"Get Started" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showinfo) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 100, 32)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIImageView *imagevc=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 75, 32)];
    imagevc.image=[UIImage imageNamed:@"navlogo.png"];
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
    
    if(index==4)
    {
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Browse Courses" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showcourse) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(0, 0, 150, 32)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    else  {
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Get Started" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showinfo) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(0, 0, 100, 32)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
    }
}

-(void)showinfo
{
    PageContentViewController *startingViewController = [self viewControllerAtIndex:3];
    
    
    viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    NSArray *subviews = self.pageViewController.view.subviews;
    UIPageControl *thisControl = nil;
    for (int i=0; i<[subviews count]; i++) {
        if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]]) {
            thisControl = (UIPageControl *)[subviews objectAtIndex:i];
            thisControl.currentPage=3;
        }
    }
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Browse Courses" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showcourse) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 150, 32)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
 

}
-(void)showcourse
{
    NSLog(@"courses page");
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
           // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
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
    if (index == [self.pageTitles count]) {
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
    return [self.pageTitles count];
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


@end
@implementation UIPageViewController (Additions)

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

@end
