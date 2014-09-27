//
//  MailDetailsViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 12/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//

#import "MailDetailsViewController.h"
#import "UIButton+Bootstrap.h"

@interface MailDetailsViewController ()

@end

@implementation MailDetailsViewController
@synthesize selectedrow;
@synthesize from;
@synthesize to;
@synthesize date;
@synthesize body;
@synthesize important;
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
    if ([selectedrow count]>0) {
        from.text=[selectedrow objectForKey:@"sender_name"];
        to.text=[selectedrow objectForKey:@"receiver_name"];
        date.text=[selectedrow objectForKey:@"sent_date"];
        body.text=[selectedrow objectForKey:@"inboxmessage"];
       imp=[selectedrow objectForKey:@"important_status"];
        if ([imp isEqualToString:@"1"])
        {
            [self.important warningStyle];
           // [self.important addAwesomeIcon:FAIconRemove beforeTitle:YES];
            
            [important setTitle:@"Remove important" forState:UIControlStateNormal];
            important.tag=11;
        }
        else
        {
            [self.important successStyle];
           // [self.important addAwesomeIcon:FAIconCheck beforeTitle:YES];
             [important setTitle:@"Mark as important" forState:UIControlStateNormal];
            important.tag=10;
            
        }
        
    }
    
    // Do any additional setup after loading the view.
}
- (IBAction)update:(UIButton*)sender
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Please wait...";
    [HUD show:YES];
    if ([sender.titleLabel.text isEqualToString:@"Remove important"])
    {
        if ([[du submitvalues]isEqualToString:@"Success"])
        {
            imp=@"0";
            [self updatereadstate:@"0"];
            [self.important successStyle];
            //[self.important addAwesomeIcon:FAIconCheck beforeTitle:YES];
      [important setTitle:@"Mark as important" forState:UIControlStateNormal];
            
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
   if ([sender.titleLabel.text isEqualToString:@"Mark as important"])
    {
        if ([[du submitvalues]isEqualToString:@"Success"])
        {
            imp=@"1";
            [self updatereadstate:@"1"];
            [self.important warningStyle];
           // [self.important addAwesomeIcon:FAIconRemove beforeTitle:YES];
            [important setTitle:@"Remove important" forState:UIControlStateNormal];
            
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"importantStatus"
                                                        object:imp
                                                      userInfo:nil];
}

-(void)updatereadstate:(NSString *)importantvalue
{
    
    NSString *response=[self HttpPostEntityFirst2:@"important" ForValue1:importantvalue EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
    
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
                [HUD hide:YES];
                NSLog(@"Inserting  Succecssful");
                
            }
            else if ([[menu objectForKey:@"success"] isEqualToString:@"No"])
                
            {
                [HUD hide:YES];
                NSLog(@"insertion failed");
                
            }
            
        }
    }
    
}
-(NSString *)HttpPostEntityFirst2:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Inbox.php?service=inboximportantstatus";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&studentid=%@&inboxid=%@&%@=%@",firstEntity,value1,[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],[selectedrow objectForKey:@"inbox_id"],secondEntity,value2];
    // NSLog(@"POST %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    return [du returndbresult:post URL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    HUD.delegate = nil;
}
@end
