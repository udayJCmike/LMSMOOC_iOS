//
//  databaseurl.m
//  webservice
//
//  Created by DeemsysInc on 6/19/14.
//  Copyright (c) 2014 DeemsysInc. All rights reserved.
//

#import "databaseurl.h"
#import "Reachability.h"
static databaseurl * appInstance;
@implementation databaseurl
+(databaseurl*)sharedInstance {
	if (!appInstance) {
		appInstance = [[databaseurl alloc] init];
        
	}
	return appInstance;
}

-(NSString*)DBurl
{
   //NSString * link=@"http://208.109.248.89:80/gpsios/service/";
     NSString * link=@"http://192.168.1.106:8888/LmsmoocIos/Services/";
    return link;
    
}
-(NSString*)submitvalues
{
    
    
    Reachability* wifiReach = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
	NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    
	switch (netStatus)
	{
		case NotReachable:
		{
			isConnect=NO;
			//NSLog(@"Access Not Available");
			break;
		}
            
		case ReachableViaWWAN:
		{
			isConnect=YES;
			//NSLog(@"Reachable WWAN");
			break;
		}
		case ReachableViaWiFi:
		{
			isConnect=YES;
			//NSLog(@"Reachable WiFi");
			break;
		}
	}
	
	
    
    if(isConnect)
    {
        
        return  @"Success";
        
    }
    
    else
    {
        
        return @"Failure";
    }
    
    
}
-(BOOL)validatePasswordForSignupPage:(NSString *)password

{
    NSString *userFormat1 =@"[A-Za-z0-9]{4,32}";
    //[(UITextField*)[self.view viewWithTag:101] resignFirstResponder];
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userFormat1];
    return [test evaluateWithObject:password];
}
-(BOOL)validateNameForSignupPage:(NSString *)firstname

{
    NSString *userFormat1 =@"[A-Za-z ]{4,32}";
    //[(UITextField*)[self.view viewWithTag:101] resignFirstResponder];
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userFormat1];
    return [test evaluateWithObject:firstname];
}

-(BOOL)validateUserNameForSignupPage:(NSString *)firstname
{
    NSString *userFormat1 =@"[A-Za-z 0-9]{6,32}";
    //[(UITextField*)[self.view viewWithTag:101] resignFirstResponder];
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userFormat1];
    return [test evaluateWithObject:firstname];
}

-(BOOL)validateMobileForSignupPage:(NSString*)mobilenumber
{
    NSCharacterSet *textremove = [NSCharacterSet characterSetWithCharactersInString:@"(-)"];
    mobilenumber= [[mobilenumber componentsSeparatedByCharactersInSet: textremove] componentsJoinedByString:@""];
   NSString *mobileFormat1 =  @"[789]{1}[0-9]{9}";
    NSPredicate *mobileTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileFormat1];
    if ([mobileTest1 evaluateWithObject:mobilenumber])
    {
        NSString *indexvalues=[mobilenumber substringWithRange: NSMakeRange (0, 3)];
        NSString *indexvalues1=[mobilenumber substringWithRange: NSMakeRange (3,3)];
        
        if (([indexvalues isEqualToString:@"000"])||([indexvalues1 isEqualToString:@"000"]))
        {
            return 0;
        }
        else
            return 1;
    }
    else
    {
        return [mobileTest1 evaluateWithObject:mobilenumber];
    }
}

-(BOOL)validateEmailForSignupPage:(NSString*)candidate
{
    NSString *emailFormat1 = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailFormat1];
    return [emailTest1 evaluateWithObject:candidate];
}

-(NSString *)returndbresult:(NSString *)post URL:(NSURL *)url
{
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    //when we user https, we need to allow any HTTPS cerificates, so add the one line code,to tell teh NSURLRequest to accept any https certificate, i'm not sure //about the security aspects
    
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
// NSLog(@"data %@",data);
    
    return data;
    
}
-(NSString *)imagecheck:(NSString*)imagename
{
    NSString *filename=imagename;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        if (screenRect.size.height == 1024.0f)
        {
            filename = [filename stringByReplacingOccurrencesOfString:@".jpg" withString:@"~ipad.jpg"];
            // code for 4-inch screen
        } else {
            filename = [filename stringByReplacingOccurrencesOfString:@".jpg" withString:@"@2x~ipad.jpg"];
            // code for 3.5-inch screen
        }
        
    }
    else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        if (screenRect.size.height == 568.0f)
        {
            filename = [filename stringByReplacingOccurrencesOfString:@".jpg" withString:@"-568h@2x.jpg"];
            // code for 4-inch screen
        } else {
            filename = [filename stringByReplacingOccurrencesOfString:@".jpg" withString:@"@2x.jpg"];
            // code for 3.5-inch screen
        }
        
    }
    return filename;
}

@end
