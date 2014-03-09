//
//  Employee.h
//  Who's Who
//
//  Created by Obyadur Rahman on 3/9/14.
//  Copyright (c) 2014 Sky World Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *biography;
@property(nonatomic, strong) NSString *photoUrl;
@property(nonatomic, strong) UIImage  *profileImage;

@end
