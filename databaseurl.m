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
#pragma mark - Class method implementation

-(NSString*)DBurl
{
   NSString * link=@"http://208.109.248.89/mobile/ios/Services/";
 //NSString * link=@"http://localhost:8888/LmsmoocIos/Services/";
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
      //return  @"Success";
       return @"Failure";
    }
    
    
}
-(BOOL)validatePasswordForSignupPage:(NSString *)password

{
    BOOL lowerCaseLetter=FALSE,upperCaseLetter=FALSE,digit=FALSE,specialCharacter=FALSE;
    int asciiValue;
    if(([password length] >= 8) && ([password length] <=25 ))
    {
        for (int i = 0; i < [password length]; i++)
        {
            unichar c = [password characterAtIndex:i];
            if(!lowerCaseLetter)
            {
                lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!upperCaseLetter)
            {
                upperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!digit)
            {
                digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
            
            asciiValue = [password characterAtIndex:i];
            if(!specialCharacter)
            {
                if(asciiValue >=33 && asciiValue <= 47)
                {
                    specialCharacter=1;
                }
                else if (asciiValue>=58 && asciiValue<=64)
                    specialCharacter=1;
                else if (asciiValue>=91 && asciiValue<=96)
                    specialCharacter=1;
                else
                {
                    //NSLog(@"else block");
                    specialCharacter=0;
                }

            }
          //  NSLog(@"ascii value---%d",asciiValue);
            
        }
        
        if(specialCharacter && digit && (lowerCaseLetter || upperCaseLetter))
        {
            //do what u want
          // NSLog(@"Valid Password %d %d %d %d",specialCharacter,digit,lowerCaseLetter,upperCaseLetter);
             return YES;
        }
        else
        {
           // NSLog(@"inValid Password %d %d %d %d",specialCharacter,digit,lowerCaseLetter,upperCaseLetter);
             return NO;
            
        }
    }
    else return NO;
//    NSString *userFormat1 =@"[A-Za-z0-9@]{4,24}";
//    //[(UITextField*)[self.view viewWithTag:101] resignFirstResponder];
//    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userFormat1];
//    return [test evaluateWithObject:password];
}
-(BOOL)validateNameForSignupPage:(NSString *)firstname

{
    NSString *userFormat1 =@"[A-Za-z ]{3,15}";
    //[(UITextField*)[self.view viewWithTag:101] resignFirstResponder];
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userFormat1];
    return [test evaluateWithObject:firstname];
}

-(BOOL)validateUserNameForSignupPage:(NSString *)firstname
{
    NSString *userFormat1 =@"[A-Za-z0-9@_-]{6,25}";
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
 //NSLog(@"data %@",data);
    
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
-(NSMutableArray *)MultipleCharacters:(NSString *)url
{
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    NSData *returnData = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];
   // NSLog(@"return string %@",returnData);
    NSString *returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    NSError *err = nil;
 // NSLog(@"return string %@",returnString);

 
    NSMutableArray *search = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
//  NSLog(@"search response %@",search);
    return search;
}
-(NSString *)MultipleCharactersHTML:(NSString *)url
{
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    NSData *returnData = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];
    
    NSString *returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    //  NSLog(@"return string %@",returnString);
    returnString=[returnString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    returnString=[returnString stringByReplacingOccurrencesOfString:@"\"<" withString:@"<"];
    returnString=[returnString stringByReplacingOccurrencesOfString:@">\"" withString:@">"];
    NSError *err = nil;
    // NSLog(@"return string replaced %@",returnString);
    
    //    NSMutableArray *search = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    //  NSLog(@"search response %@",search);
    return returnString;
}

@end
