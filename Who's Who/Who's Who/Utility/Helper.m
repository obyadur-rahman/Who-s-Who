//
//  Helper.m
//  Who's Who
//
//  Created by Obyadur Rahman on 3/9/14.
//  Copyright (c) 2014 Sky World Inc. All rights reserved.
//

#import "Helper.h"
#import "Reachability.h"

@implementation Helper

// -------------------------------------------------------------------------------
//	getNibNameForClass:
// -------------------------------------------------------------------------------
+ (NSString *)getNibNameForClass:(Class)givenClass
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return [NSString stringWithFormat:@"%@~iPad", NSStringFromClass(givenClass)];
    }
    else
    {
        return [NSString stringWithFormat:@"%@~iPhone", NSStringFromClass(givenClass)];
    }
}

// -------------------------------------------------------------------------------
//	getDocumentDirectoryPath
// -------------------------------------------------------------------------------
+ (NSString *)getDocumentDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}


// -------------------------------------------------------------------------------
//	getDocumentsEmployeeFilePath
// -------------------------------------------------------------------------------
+ (NSString *)getDocumentsEmployeeFilePath
{
    NSString *employeeFileName = [[self getDocumentDirectoryPath] stringByAppendingString:@"/employee.archive"];
    return employeeFileName;
}

// -------------------------------------------------------------------------------
//	saveEmployeeData:
// -------------------------------------------------------------------------------
+ (void)saveEmployeeData:(NSMutableArray *)employeeData
{
    if (employeeData != nil && employeeData.count != 0)
    {
        NSString *filePath = [self getDocumentsEmployeeFilePath];
        [employeeData writeToFile:[self getDocumentsEmployeeFilePath] atomically:YES];
        BOOL success = [[NSKeyedArchiver archivedDataWithRootObject:employeeData] writeToFile:filePath atomically:YES];
        if (success)
        {
            NSLog(@"Successful write");
        }
        else
        {
            NSLog(@"Failed write");
        }
    }
}

// -------------------------------------------------------------------------------
//	getEmployeeData
// -------------------------------------------------------------------------------
+ (NSMutableArray *)getEmployeeData
{
    NSString *filePath = [self getDocumentsEmployeeFilePath];
    NSMutableArray *employees = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];;
    return employees;
}


// -------------------------------------------------------------------------------
//	isConnectionAvailable
// -------------------------------------------------------------------------------
+ (BOOL)isConnectionAvailable
{
    NetworkStatus internetStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (internetStatus == NotReachable)
    {
        return NO;
    }
    else if (internetStatus == ReachableViaWiFi)
    {
        return YES;
    }
    else if (internetStatus == ReachableViaWWAN)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
