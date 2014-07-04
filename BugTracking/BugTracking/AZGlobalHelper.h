//
//  AZGlobalHelper.h
//  BugTracking
//
//  Created by Rajendra on 04/07/14.
//  Copyright (c) 2014 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AZUserInfo.h"

@interface AZGlobalHelper : NSObject

@property (nonatomic, strong) AZUserInfo *userInfo;

//singletone function
+(AZGlobalHelper*) sharedManager;

@end
