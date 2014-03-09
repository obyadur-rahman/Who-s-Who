//
//  Employee.m
//  Who's Who
//
//  Created by Obyadur Rahman on 3/9/14.
//  Copyright (c) 2014 Sky World Inc. All rights reserved.
//

#import "Employee.h"

@implementation Employee

@synthesize name = _name, title = _title, biography = _biography, photoUrl = _photoUrl, profileImage=_profileImage;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.biography = [aDecoder decodeObjectForKey:@"biography"];
        self.photoUrl = [aDecoder decodeObjectForKey:@"photoUrl"];
        self.profileImage = [aDecoder decodeObjectForKey:@"profileImage"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.biography forKey:@"biography"];
    [aCoder encodeObject:self.photoUrl forKey:@"photoUrl"];
    [aCoder encodeObject:self.profileImage forKey:@"profileImage"];
}

@end
