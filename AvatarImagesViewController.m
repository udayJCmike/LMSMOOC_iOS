//
//  AvatarImagesViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 11/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "AvatarImagesViewController.h"
#import "Avatarimagecell.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
@interface AvatarImagesViewController ()
{
    NSString *url;
    NSString *imagepath;
}
@end

@implementation AvatarImagesViewController
@synthesize gendervalue;
@synthesize imageQueue;
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
    delegate=AppDelegate;
    self.collectionView.allowsMultipleSelection=NO;
    avatarimages=[[NSMutableArray alloc]init];
    imagedata=[[NSMutableArray alloc]init];
    imageURL=[[NSMutableArray alloc]init];
     imagepath=@"/resources/images/users/";
    gendervalue=[delegate.Profiledetails objectForKey:@"gender"];
    NSLog(@"gender value %@",gendervalue);
   
   
    if ([gendervalue isEqualToString:@"male"])
    {
        for (int i=1; i<=13; i++)
        {
             url= [NSString stringWithFormat:@"%@%@",delegate.avatharURL,imagepath];
            [avatarimages addObject:[UIImage imageNamed:@"placeholder.png"]];
              [imageURL addObject:[NSString stringWithFormat:@"%@%d.png",url,i]];

           
        }
    }
    else if ([gendervalue isEqualToString:@"female"])
    {
        for (int j=1; j<=14; j++)
        {
            url= [NSString stringWithFormat:@"%@%@",delegate.avatharURL,imagepath];
            [imageURL addObject:[NSString stringWithFormat:@"%@g%d.png",url,j]];
            [avatarimages addObject:[UIImage imageNamed:@"placeholder.png"]];
          
          
        }
    }

     imageQueue = dispatch_group_create();
    
    dispatch_group_async(imageQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                         ^{
                             imagedata=[[NSMutableArray alloc]init];
                                     
                             for (int i=0; i<[imageURL count]; i++)
                             {
                                 NSLog(@"clicked ");
                             
                               [imagedata addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[imageURL objectAtIndex:i]]]]];
                                 
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"Avatardownloaded"
                                                                                         object:imagedata
                                                                                       userInfo:nil];
                                 }
                         
                             
                            
                            
                       
//                             dispatch_async(dispatch_get_main_queue(), ^{
//                                 
//                             });
                             
                             
                         });
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadimages:)
                                                 name:@"Avatardownloaded"
                                               object:nil];
}
-(void)selectedvalue:(NSInteger)row
{
    NSString *res;
    if ([gendervalue isEqualToString:@"male"])
    {
       res= [NSString stringWithFormat:@"%@%ld.png",imagepath,(long)row+1];
    }
    else if ([gendervalue isEqualToString:@"female"])
    {
       res= [NSString stringWithFormat:@"%@g%ld.png",imagepath,(long)row+1];
    }
    [delegate.Profiledetails setValue:res forKey:@"avatarImage"];
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)loadimages:(id)sender
    {
      
       NSMutableArray *temp= [sender valueForKey:@"object"];
    
 [avatarimages replaceObjectAtIndex:[temp count]-1 withObject:[temp lastObject]];
//            [avatarimages insertObject:[temp lastObject] atIndex:[temp count]-1];

        [self.collectionView reloadData];

    }
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2.0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return avatarimages.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSLog(@"clicked at index %ld",(long)indexPath.row);
    NSString *nameSelected = [avatarimages objectAtIndex:indexPath.row];
    
    
    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = [UIColor blueColor];
    datasetCell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame-selected.png"]];//
    [self selectedvalue:indexPath.row];
   
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Image";
    
    
    Avatarimagecell *cell = (Avatarimagecell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell.avatar_image setImage:[avatarimages objectAtIndex:indexPath.row]];

    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame-selected.png"]];
  [self.collectionView bringSubviewToFront:cell.selectedBackgroundView];
   
//    if(indexPath.row==courselist.count-1)
//    {
//        //do code for loading additional datas...
//    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    return YES;
}
-(void)viewDidUnload
{
   // dispatch_suspend(imageQueue);
    
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Avatardownloaded" object:nil];
    [[NSNotificationCenter defaultCenter]release];
//    [avatarimages release];
//    [imagedata release];
//    [imageURL release];
    dispatch_release(imageQueue);
    
}
-(void)dealloc
{
    [super dealloc];

}

@end
