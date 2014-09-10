//
//  databaseurl.h
//  webservice
//
//  Created by DeemsysInc on 6/19/14.
//  Copyright (c) 2014 DeemsysInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface databaseurl : NSObject
{
    BOOL isConnect;
    NSString *Headername;
}
+(databaseurl*)sharedInstance;
-(NSString*)submitvalues;
- (NSString*) DBurl;
-(NSString *)returndbresult:(NSString *)post URL:(NSURL *)url;
-(NSString *)imagecheck:(NSString*)imagename;
-(BOOL)validateNameForSignupPage:(NSString *)firstname;
-(BOOL)validateMobileForSignupPage:(NSString*)mobilenumber;
-(BOOL)validateEmailForSignupPage:(NSString*)candidate;
-(BOOL)validateOtherNameForSignupPage:(NSString *)firstname;
-(BOOL)validatePasswordForSignupPage:(NSString *)password;
-(BOOL)validateUserNameForSignupPage:(NSString *)firstname;
@end
