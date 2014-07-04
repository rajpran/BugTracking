//
//  AZGlobalHelper.m
//  BugTracking
//
//  Created by Rajendra on 04/07/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import "AZGlobalHelper.h"


@implementation AZGlobalHelper

//singletone function
+(AZGlobalHelper*) sharedManager{
    
    static AZGlobalHelper * sharedManager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager=[[self alloc] init];
    });
    return sharedManager;
}
@end
