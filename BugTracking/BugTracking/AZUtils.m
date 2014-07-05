//
//  AZUtils.m
//  BugTracking
//
//  Created by Rajendra on 05/07/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "AZUtils.h"

@implementation AZUtils

+(NSString *)getDocsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

+(BOOL)setPlist:(NSString *)strPlistName {
    NSError *error;
    NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strPlistName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:strPlistName ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:path error:&error];
        return YES;
    }
    else {
        return NO;
    }
}

+(void)setPlistData:(NSString *)strPlistName key:(NSString *)key value:(NSDictionary *)value {
    
    [self setPlist:strPlistName];
    
    NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strPlistName]];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    [data setObject:value forKey:key];
    //[data setObject:[NSNumber numberWithInt:strValue] forKey:key];
    
    [data writeToFile:path atomically:YES];
}

+(id)getPlistData:(NSString *)strPlistName key:(NSString *)key {
    [self setPlist:strPlistName];
    
    NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strPlistName]];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    return [data objectForKey:key];
}

@end
