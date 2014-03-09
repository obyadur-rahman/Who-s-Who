//
//  ImageDownloader.h
//  Who's Who
//
//  Created by Obyadur Rahman on 3/9/14.
//  Copyright (c) 2014 Sky World Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Employee;

@interface ImageDownloader : NSObject

@property (nonatomic, strong) Employee *employee;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end

