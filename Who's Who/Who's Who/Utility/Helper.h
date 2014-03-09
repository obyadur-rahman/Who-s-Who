//
//  Helper.h
//  Who's Who
//
//  Created by Obyadur Rahman on 3/9/14.
//  Copyright (c) 2014 Sky World Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

// get nib name for given class
+ (NSString *)getNibNameForClass:(Class)givenClass;

// document directory path
+ (NSString *)getDocumentDirectoryPath;

// Archive/Unachieve employee data
+ (NSMutableArray *)getEmployeeData;
+ (void)saveEmployeeData:(NSMutableArray *)employeeData;

// Network Status
+ (BOOL)isConnectionAvailable;

@end
