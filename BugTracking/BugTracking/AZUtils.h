//
//  AZUtils.h
//  BugTracking
//
//  Created by Rajendra on 05/07/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZUtils : NSObject

+(NSString *)getDocsDirectory;
+(BOOL)setPlist:(NSString *)strPlistName;
+(void)setPlistData:(NSString *)strPlistName key:(NSString *)key value:(NSDictionary *)strValue;
+(id)getPlistData:(NSString *)strPlistName key:(NSString *)key;

@end
