//
//  ProfileUpdateViewController.m
//  LMSMOOC
//
//  Created by DeemsysInc on 10/09/14.
//  Copyright (c) 2014 deemsys. All rights reserved.
//
#import "Passwordchange.h"
#import "ProfileUpdateViewController.h"
#import "lmsmoocAppDelegate.h"
#import "databaseurl.h"
#import "SBJSON.h"
#import "DashboardContentListTableViewController.h"
#import "AvatarImagesViewController.h"
#import "UIButton+Bootstrap.h"
#import "DXAlertView.h"
#define  AppDelegate (lmsmoocAppDelegate *)[[UIApplication sharedApplication] delegate]
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_35 (SCREEN_HEIGHT == 480)
#define SCREEN_40 (SCREEN_HEIGHT == 568)
@interface ProfileUpdateViewController ()
{
    DashboardContentListTableViewController *list;
    databaseurl *du;
    lmsmoocAppDelegate *delegate;
}
@end

@implementation ProfileUpdateViewController
@synthesize fname;
@synthesize lname;
@synthesize username;
@synthesize email;
@synthesize password;
@synthesize upload;
@synthesize urllabel;
@synthesize bg;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    password.text=[delegate.Profiledetails objectForKey:@"password"];
     
//    NSLog(@"value image %@",[delegate.Profiledetails valueForKey:@"avatarImage"]);
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.saveprofile primaryStyle];
    [self.browse primaryStyle];
    [self.upload primaryStyle];
    // Do any additional setup after loading the view.
    if (self.navigationController.navigationBar.hidden == YES)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    list=[[DashboardContentListTableViewController alloc]init];
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
    uploaded=false;
    upload.hidden=YES;
    urllabel.hidden=YES;
    fname.delegate = self;
    lname.delegate=self;
    username.delegate=self;
    password.delegate = self;
  
    email.delegate=self;
    interestedval=@"null";
    genderval=@"null";
    UITapGestureRecognizer *get=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:get];
    
   delegate=AppDelegate;
    if(delegate.Profiledetails)
    {
        [self setvalues];
    }
    
    bg.layer.cornerRadius=10;
    bg.layer.masksToBounds=YES;
    
}

-(void)setvalues
{
  delegate=AppDelegate;
    fname.text=[delegate.Profiledetails objectForKey:@"firstname"];
   lname.text=[delegate.Profiledetails objectForKey:@"lastname"];
    username.text=[delegate.Profiledetails objectForKey:@"username"];
    email.text=[delegate.Profiledetails objectForKey:@"email"];
    password.text=[delegate.Profiledetails objectForKey:@"password"];
    interestedval=[delegate.Profiledetails objectForKey:@"interested_in"];
    genderval=[delegate.Profiledetails objectForKey:@"gender"];
    
    if ([genderval isEqualToString:@"female"]) {
        imagename=[delegate.Profiledetails objectForKey:@"avatarImage"];
        [_gender setSelectedSegmentIndex:1];
    }
    else if ([genderval isEqualToString:@"male"]){
        imagename=[delegate.Profiledetails objectForKey:@"avatarImage"];
        [_gender setSelectedSegmentIndex:0];
    }
    else
    {
        imagename=@"";
         [_gender setSelectedSegmentIndex:UISegmentedControlNoSegment];
        
    }
    if ([interestedval isEqualToString:@"courses"]) {
        [_interestedin setSelectedSegmentIndex:1];
    }
    else if([interestedval isEqualToString:@"subject"]) {
        [_interestedin setSelectedSegmentIndex:0];
    }
    else
    {
        interestedval=@"";
        [_interestedin setSelectedSegmentIndex:UISegmentedControlNoSegment];
    }

    
}
-(void)dismissKeyboard
{
    [fname resignFirstResponder];
    [lname resignFirstResponder];
    [username resignFirstResponder];
    [email resignFirstResponder];

    [password resignFirstResponder];
    
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

- (IBAction)signup:(id)sender {
    int c=1;
    [self dismissKeyboard];
    if (fname.text.length>0 &&
        lname.text.length>0 &&
        username.text.length>0 &&
        email.text.length>0
         )
    {
        if ([du validateNameForSignupPage:fname.text])
        {
            if ([du validateNameForSignupPage:lname.text])
            {
                
                if ([du validateUserNameForSignupPage:username.text])
                {
                    if ([du validateEmailForSignupPage:email.text])
                    {
                        
                            if (![interestedval isEqualToString:@"null"] && [interestedval length]!=0) {
                                
                                if (![genderval isEqualToString:@"null"]&& [genderval length]!=0) {
                                    c=1;
                                }
                                else
                                {
                                    c=0;
                                    [self ShowAlert:@"Enter gender." title:@"Gender"];
                                }
                            }
                            else
                            {
                                c=0;
                                [self ShowAlert:@"Enter interested in." title:@"Interested in"];
                            }
                            
                            [delegate.Profiledetails setValue:fname.text forKey:@"firstname"];
                            [delegate.Profiledetails setValue:lname.text forKey:@"lastname"];
                            [delegate.Profiledetails setValue:email.text forKey:@"email"];
                            [delegate.Profiledetails setValue:interestedval forKey:@"interested_in"];
                            [delegate.Profiledetails setValue:genderval forKey:@"gender"];
//                            [delegate.Profiledetails setValue:[menu objectForKey:@"avatarURL"] forKey:@"avatarURL"];
//                            [delegate.Profiledetails setValue:[menu objectForKey:@"avatarImage"] forKey:@"avatarImage"];
//                            [delegate.Profiledetails setValue:[menu objectForKey:@"logins"] forKey:@"logins"];
                           
                    
                       //     NSLog(@"dictionary values %@",delegate.Profiledetails);
                    }
                   else
                    {
                        c = 0;
                        if ([email.text length]==0) {
                            [self ShowAlert:@"Enter the email ID." title:@"Email id"];
                        }
                        else
                        {
                            [self ShowAlert:@"Should contain alphabets.\nShould contain numbers.\nShould contain 1 special character.\nShould be 10 to 40 characters." title:@"Email id"];
                            
                        }
                        // NSLog(@"ENTER VALID email id");
                        
                    }
                }
                else
                {
                    c = 0;
                    if ([username.text length]==0) {
                        [self ShowAlert:@"Enter the username." title:@"Username"];
                    }
                    else
                    {
                        [self ShowAlert:@"Should contain alphabets.\nShould contain numbers.\nShould contain special characters @_-.\nShould be 6 to 25 characters." title:@"Username"];
                        
                    }
                    NSLog(@"ENTER VALID username");
                    
                }
            }
            else
            {
                c=0;
                if ([lname.text length]==0) {
                    [self ShowAlert:@"Enter the lastname." title:@"Lastname"];
                }
                else
                {
                    [self ShowAlert:@"Should contain alphabets.\nShould be 3 to 15 characters." title:@"Lastname"];
                    
                }
                // NSLog(@"ENTER VALID LAST NAME");
                
            }
        }
        else
        {
            c=0;
            if ([fname.text length]==0) {
                [self ShowAlert:@"Enter the firstname." title:@"Firstname"];
            }
            else
            {
                [self ShowAlert:@"Should contain alphabets.\nShould be 3 to 15 characters." title:@"Firstname"];
                
            }
            //  NSLog(@"ENTER VALID FIRST NAME");
            
        }
    }
    else
    {
        c=0;
        //enter all required fields
       [self ShowAlert:@"Enter all required fields." title:@"Info"];
        
        
    }
    if (c==1)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
        HUD.mode=MBProgressHUDModeIndeterminate;
        HUD.delegate = self;
        HUD.labelText = @"Please wait";
        [HUD show:YES];
        if ([[du submitvalues]isEqualToString:@"Success"])
        {
            [self signupdata];
        }
        else
        {
            //[HUD hide:YES];
            HUD.labelText = @"Check network connection";
            HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]] autorelease];
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD hide:YES afterDelay:1];
        }
        
    }
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    switch (textField.tag) {
        case 1:
            if ([du validateNameForSignupPage:fname.text])
            {
                
            }
            else
            {
                
                if ([fname.text length]==0) {
                    [self ShowAlert:@"Enter the firstname." title:@"Firstname"];
                }
                else
                {
                    [self ShowAlert:@"Should contain only alphabets.\nShould be 3 to 15 characters." title:@"Firstname"];
                    
                }
                
                
            }
            break;
        case 2:
            if ([du validateNameForSignupPage:lname.text])
            {
            }
            else
            {
                
                if ([lname.text length]==0) {
                    [self ShowAlert:@"Enter the lastname."title:@"Lastname"];
                }
                else
                {
                    [self ShowAlert:@"Should contain only alphabets.\nShould be 3 to 15 characters."title:@"Lastname"];
                    
                }
                // NSLog(@"ENTER VALID LAST NAME");
                
            }
            break;
        case 3:
            if ([du validateUserNameForSignupPage:username.text])
            {
                HUD = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
                HUD.mode=MBProgressHUDModeIndeterminate;
                HUD.delegate = self;
                HUD.labelText = @"Please wait";
                [HUD show:YES];
                NSString *response=[self HttpPostEntityUsername:@"username" ForValue1:textField.text  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
                
                NSError *error;
                SBJSON *json = [[SBJSON new] autorelease];
                NSDictionary *parsedvalue = [json objectWithString:response error:&error];
                
                //  NSLog(@"%@ parsed valued",parsedvalue);
                if (parsedvalue == nil)
                {
                    //NSLog(@"parsedvalue == nil");
                    [HUD hide:YES];
                }
                else
                {
                    
                    NSDictionary* menu = [parsedvalue objectForKey:@"serviceresponse"];
                    [HUD hide:YES];
                    if ([[menu objectForKey:@"success"] isEqualToString:@"Yes"])
                    {
                        [HUD hide:YES];
                    }
                    else  if ([[menu objectForKey:@"emaill"] isEqualToString:@"usernameexist"])
                    {
                        [self ShowAlert:@"Username exist." title:@"Username"];
                    }
                }
                
                
            }
            else
            {
                
                if ([username.text length]==0) {
                    [self ShowAlert:@"Enter the username." title:@"Username"];
                }
                else
                {
                    [self ShowAlert:@"Should contain alphabets.\nShould contain numbers.\nShould contain special characters @_-.\nShould be 6 to 25 characters." title:@"Username"];
                    
                }
                //  NSLog(@"ENTER VALID username");
                
            }
            
            break;
        case 4:
            if ([du validateEmailForSignupPage:email.text])
            {
                if (![[delegate.Profiledetails valueForKey:@"email"]isEqualToString:email.text]) {
                    
                
                HUD = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
                HUD.mode=MBProgressHUDModeIndeterminate;
                HUD.delegate = self;
                HUD.labelText = @"Please wait";
                [HUD show:YES];
                NSString *response=[self HttpPostEntityEmail:@"email" ForValue1:textField.text  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
                
                NSError *error;
                SBJSON *json = [[SBJSON new] autorelease];
                NSDictionary *parsedvalue = [json objectWithString:response error:&error];
                
                //  NSLog(@"%@ parsed valued",parsedvalue);
                if (parsedvalue == nil)
                {
                    //NSLog(@"parsedvalue == nil");
                    [HUD hide:YES];
                }
                else
                {
                    
                    NSDictionary* menu = [parsedvalue objectForKey:@"serviceresponse"];
                    [HUD hide:YES];
                    if ([[menu objectForKey:@"success"] isEqualToString:@"Yes"])
                    {
                        [HUD hide:YES];
                    }
                    else  if ([[menu objectForKey:@"emaill"] isEqualToString:@"emailexist"])
                    {
                        [self ShowAlert:@"Email id exist." title:@"Email id"];
                    }
                }
                }
            }
            else
            {
                
                if ([email.text length]==0) {
                    [self ShowAlert:@"Enter the email ID." title:@"Email id"];
                }
                else
                {
                    [self ShowAlert:@"Should contain alphabets.\nShould contain numbers.\nShould contain 1 special character.\nShould be 10 to 40 characters."title:@"Email id"];
                    
                }
                // NSLog(@"ENTER VALID email id");
                
            }
            break;
            
        default:
            break;
    }
    
    
}

-(void)reset
{
    
    fname.text=@"";
    lname.text=@"";
    email.text=@"";
   
    
    
}

-(IBAction)browseimage:(id)sender
{
  /*  if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        if ([self.popovercontroller isPopoverVisible]) {
            [self.popovercontroller dismissPopoverAnimated:YES];
            [popovercontroller release];
        }
        else
        {
          [self SelectPhotoFromLibrary];
        }
        
        
        
    }
    UIActionSheet *actionSheet=nil;
     if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        
    actionSheet = [[UIActionSheet alloc] initWithTitle:@""delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
             otherButtonTitles:@"Select Photo From Library", @"Cancel", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.destructiveButtonIndex = 1;
    [actionSheet showInView:self.view];
    actionSheet.tag=1;
    }
    
    */
    
    
    UIActionSheet *actionSheet=nil;
    actionSheet = [[UIActionSheet alloc] initWithTitle:@""delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
                                     otherButtonTitles:@"Select Photo From Library", @"Cancel", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.destructiveButtonIndex = 1;
     actionSheet.tag=1;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // In this case the device is an iPad.
        [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];
    }
    else{
        // In this case the device is an iPhone/iPod Touch.
        [actionSheet showInView:self.view];
    }
    
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag==1)
    {

    if (buttonIndex == 0)
        {
          
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
                if ([self.popovercontroller isPopoverVisible]) {
                    [self.popovercontroller dismissPopoverAnimated:YES];
                    [popovercontroller release];
                }
                else
                {
                    
                    [self SelectPhotoFromLibrary];
                }
                
                
                
            }
            else
            {
                  [self SelectPhotoFromLibrary];
            }
        }
        
        else if (buttonIndex == 1)
        {
            NSLog(@"cancel");
        }
        
    }

}
-(void) TakePhotoWithCamera
{
    [self startCameraPickerFromViewController:self usingDelegate:self];
}

-(void) SelectPhotoFromLibrary
{
    [self startLibraryPickerFromViewController:self usingDelegate:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)startCameraPickerFromViewController:(UIViewController*)controller usingDelegate:(id<UIImagePickerControllerDelegate>)delegateObject
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        picker.delegate = self;
        
        [controller presentViewController:picker animated:YES completion:nil];
        
    }
    return YES;
}

- (BOOL)startLibraryPickerFromViewController:(UIViewController*)controller usingDelegate:(id<UIImagePickerControllerDelegate>)delegateObject
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker1 = [[UIImagePickerController alloc]init];
        picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker1.allowsEditing = YES;
        picker1.delegate = self;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
            [controller presentViewController:picker1 animated:YES completion:nil];
        }
       
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
           
            self.popovercontroller = [[UIPopoverController alloc]initWithContentViewController:picker1];
            
            popovercontroller.delegate = self;
            
            [self.popovercontroller presentPopoverFromRect:CGRectMake(275, 270, 200, 200) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny             animated:NO];
            
           // [picker1 release];
            
        }
        
    }
    
        
    
        
   

    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
      UIImage* originalImage = nil;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        [self.popovercontroller dismissPopoverAnimated:true];
        [popovercontroller release];
        NSString *mediaType = [info  objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
            
        }
        
    }
        else  if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        
             originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
        }
  
   
    NSData *newda = UIImageJPEGRepresentation(originalImage,1.0f);
    [[NSUserDefaults standardUserDefaults]setValue:newda forKey:@"myimage"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    urllabel.text=[NSString stringWithFormat:@"%@",imagePath];
    upload.hidden=NO;
    urllabel.hidden=NO;
//    NSString *imageName = [imagePath lastPathComponent];
    
    
    [[picker parentViewController] dismissViewControllerAnimated:YES completion:nil];
    UINavigationController* navController = self.navigationController;
    UIViewController* controller = [navController.viewControllers objectAtIndex:0];
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self useImage];
    
}
-(void)useImage
{
 
    if(isMyCtView == YES)
    {
        isMyCtView = NO;
        
        
    }
}
- (IBAction)upload:(id)sender

{
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    
    HUD.mode=MBProgressHUDModeIndeterminate;
    
    HUD.delegate = self;
    
    HUD.labelText = @"Please wait";
    
    [HUD show:YES];
    
    [self performSelector:@selector(uploadfile) withObject:self afterDelay:0.1f];
    
    
    
}

-(void)uploadfile

{
    
    NSString *userid=[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
    
    NSString* name=[NSString stringWithFormat:@"S%@.jpg",userid ];
    
    
    
    NSString *res=[self uploadClicked:name data: [[NSUserDefaults standardUserDefaults]valueForKey:@"myimage"]];
    
    
    
    if (res) {
        
        
        
        uploaded=true;
        
    }
    
    else
        
    {
        
        uploaded=false;
        
    }
    
    [HUD hide:YES];
    
    
    
}


-(void)signupdata
{
    NSString *first= [fname.text capitalizedString];
   
    NSString *response=[self HttpPostEntityFirst1:@"firstname" ForValue1:first  EntitySecond:@"authkey" ForValue2:@"rzTFevN099Km39PV"];
    
    NSError *error;
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *parsedvalue = [json objectWithString:response error:&error];
    
    //  NSLog(@"%@ parsed valued",parsedvalue);
    if (parsedvalue == nil)
    {
        //NSLog(@"parsedvalue == nil");
        [HUD hide:YES];
    }
    else
    {
        
        NSDictionary* menu = [parsedvalue objectForKey:@"serviceresponse"];
        if ([[menu objectForKey:@"servicename"] isEqualToString:@"Signupupdate"])
        {
            if ([[menu objectForKey:@"success"] isEqualToString:@"Yes"])
            {
                
                NSLog(@"Updation  Succecssful");
                
                [HUD hide:YES];
          
                
                
                //                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
                //                {
                //                    UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"Welcome_iPad" bundle:nil];
                //                    UIViewController *initialvc=[welcome instantiateInitialViewController];
                //                    [self.navigationController pushViewController:initialvc animated:YES];
                //                }
                //                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                //                {
                //                    UIStoryboard *welcome=[UIStoryboard storyboardWithName:@"Welcome_iPhone" bundle:nil];
                //                    UIViewController *initialvc=[welcome instantiateInitialViewController];
                //                    [self.navigationController pushViewController:initialvc animated:YES];
                //                }
            }
            else if ([[menu objectForKey:@"success"] isEqualToString:@"No"])
                
            {
                [HUD hide:YES];
                
                    NSLog(@"Updation failed");
                
                
            }
            
        }
    }
    
}
-(NSString *)HttpPostEntityFirst1:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    NSString *avatar;
    NSString *userid=[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
    NSString *second= [lname.text capitalizedString];
  
    if (uploaded) {
        avatar=[NSString stringWithFormat:@"S%@.jpg",userid ];
       
    }
    else if ([genderval isEqualToString:@"female"]) {
       
        avatar=@"Sgdefault.jpg";
    }
    else if ([genderval isEqualToString:@"male"])
    {
       avatar=@"Sbdefault.jpg";
    }
    else
    {
        avatar=imagename;
    }
    
    [delegate.Profiledetails setValue:avatar forKey:@"avatarImage"];
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Signup.php?service=signupupdate";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&lastname=%@&username=%@&emailid=%@&interested=%@&gender=%@&id=%@&avatar=%@&%@=%@",firstEntity,value1,second,username.text,email.text,interestedval,genderval,[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"],avatar,secondEntity,value2];
      NSLog(@"POST %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    return [du returndbresult:post URL:url];
}
- (NSString*)uploadClicked:(NSString *)imagename1 data:(NSData*)imageData
{
    
//  // addImageData=[UIImage imageNamed:@"menu_icon.png"];
//    NSData *imageData;
//    @try {
//         imageData = UIImageJPEGRepresentation(addImageData, 90);
//    }
//    @catch (NSException *exception) {
//        NSLog(@"exception %@",exception);
//    }
   
   
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Signup.php?service=imageUpload";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *urlString = url2;
    
    // setting up the request object now
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    /*
     add some header info now
     we always need a boundary when we post a file
     also we need to set the content type
     
     You might want to generate a random boundary.. this is just the same
     as my output from wireshark on a valid html post
     */
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
     */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",imagename1]dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	//NSLog(@"body %@",body);
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	

  //  NSLog(@"returndat %@",returnString);
    return returnString;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == username)
    {
        NSString *rangeOfString = @" ";
        NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
        if(![string isEqualToString:@""])
        {
            if (range.location == 0 && [rangeOfCharacters characterIsMember:[string characterAtIndex:0]] )
            {
                
                return NO;
            }
            for (int i = 0; i<[string length]; i++)
            {
                UniChar c1 = [string characterAtIndex:i];
                if ([rangeOfCharacters characterIsMember:c1])
                {
                    return NO;
                }
            }
        }
    }

    else if (textField == fname)
    {
        NSString *rangeOfString = @" ";
        NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
        //        for (int i = 0; i<[string length]; i++)
        //        {
        //            UniChar c1 = [string characterAtIndex:i];
        //            if ([rangeOfCharacters characterIsMember:c1])
        //            {
        //                return NO;
        //            }
        //        }
        if(![string isEqualToString:@""])
        {
            if (range.location == 0 && [rangeOfCharacters characterIsMember:[string characterAtIndex:0]] )
            {
                
                return NO;
            }
        }
        if (textField)
        {
            NSString *rangeOfString = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ";
            NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
            for (int i = 0; i<[string length]; i++)
            {
                UniChar c = [string characterAtIndex:i];
                if (![rangeOfCharacters characterIsMember:c])
                {
                    return NO;
                }
            }
            return YES;
        }
        
        
    }
    else if (textField == lname)
    {
        NSString *rangeOfString = @" ";
        NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
        //        for (int i = 0; i<[string length]; i++)
        //        {
        //            UniChar c1 = [string characterAtIndex:i];
        //            if ([rangeOfCharacters characterIsMember:c1])
        //            {
        //                return NO;
        //            }
        //        }
        if(![string isEqualToString:@""])
        {
            if (range.location == 0 && [rangeOfCharacters characterIsMember:[string characterAtIndex:0]] )
            {
                
                return NO;
            }
        }
        if (textField)
        {
            NSString *rangeOfString = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ";
            NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
            for (int i = 0; i<[string length]; i++)
            {
                UniChar c = [string characterAtIndex:i];
                if (![rangeOfCharacters characterIsMember:c])
                {
                    return NO;
                }
            }
            return YES;
        }
        
        
    }
    else if(textField == email)
    {
        NSString *rangeOfString = @" ";
        NSCharacterSet *rangeOfCharacters = [NSCharacterSet characterSetWithCharactersInString:rangeOfString];
        if(![string isEqualToString:@""])
        {
            if (range.location == 0 && [rangeOfCharacters characterIsMember:[string characterAtIndex:0]] )
            {
                
                return NO;
            }
            for (int i = 0; i<[string length]; i++)
            {
                UniChar c1 = [string characterAtIndex:i];
                if ([rangeOfCharacters characterIsMember:c1])
                {
                    return NO;
                }
            }
        }
        
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)genderact:(id)sender {
    if ([sender selectedSegmentIndex]==0) {
    genderval=@"male";
    }
    else if ([sender selectedSegmentIndex]==1) {
        genderval=@"female";
    }
     [delegate.Profiledetails setValue:genderval forKey:@"gender"];
 
}
- (IBAction)interested:(id)sender {
    if ([sender selectedSegmentIndex]==0) {
        interestedval=@"subject";
    }
    else if ([sender selectedSegmentIndex]==1) {
        interestedval=@"courses";
    }
}
- (IBAction)changepwd:(id)sender {
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
//        Password_ipadViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PasswordChange"];
//        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
//        loginVC.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
//        [self presentViewController:loginVC animated:YES completion:nil];
        Passwordchange *mpvc=[Passwordchange alloc];
        
        mpvc=[mpvc initWithFrame:CGRectMake(0,0,1024,1024)];
          mpvc.transform = CGAffineTransformMakeRotation(4.71);
        
        [self.view addSubview:mpvc];
     
    }
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        Passwordchange *mpvc=[Passwordchange alloc];
        
        
        mpvc=[mpvc initWithFrame:CGRectMake(0,0,320,568)];
    }
   
   
}
-(void)ShowAlert:(NSString*)message title:(NSString *)title
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
}
-(NSString *)HttpPostEntityUsername:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Signup.php?service=usernameExist";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&%@=%@",firstEntity,value1,secondEntity,value2];
    //  NSLog(@"POST %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    return [du returndbresult:post URL:url];
}
-(NSString *)HttpPostEntityEmail:(NSString*)firstEntity ForValue1:(NSString*)value1 EntitySecond:(NSString*)secondEntity ForValue2:(NSString*)value2
{
    NSString *second= [lname.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    second= [second uppercaseString];
    NSString *urltemp=[[databaseurl sharedInstance]DBurl];
    NSString *url1=@"Signup.php?service=emailExist";
    NSString *url2=[NSString stringWithFormat:@"%@%@",urltemp,url1];
    NSString *post =[[NSString alloc] initWithFormat:@"%@=%@&%@=%@",firstEntity,value1,secondEntity,value2];
    //  NSLog(@"POST %@",post);
    NSURL *url = [NSURL URLWithString:url2];
    return [du returndbresult:post URL:url];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ( HUD!=nil) {
        
        HUD . Delegate = nil ;
        
        HUD = nil ;
        
    }
}




-(void)dealloc
{

   
    [super dealloc];
   
    if ( HUD!=nil) {
        
        HUD . Delegate = nil ;
        
        HUD = nil ;
        
    }
}


@end



