//
//  EmployeeCell.m
//  Who's Who
//
//  Created by Obyadur Rahman on 3/9/14.
//  Copyright (c) 2014 Sky World Inc. All rights reserved.
//

#import "EmployeeCell.h"

@implementation EmployeeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCell
{
    // set cell border color
    //
    [self.contentView.layer setBorderColor:[UIColor redColor].CGColor];
    [self.contentView.layer setBorderWidth:2.0f];
    
    // make cell imageview rounded
    //
    self.profileImageView.layer.cornerRadius = 5.0f;
    self.profileImageView.clipsToBounds = YES;
    
    self.__nameLabel.numberOfLines = 0;
    self.__nameLabel.text = @" Name\n\n";
    
    self.__titleLabel.text = @" Title";
    
    self.__biographyLabel.numberOfLines = 0;
    self.__biographyLabel.text = @" Biography\n\n\n\n";
    
    self.nameLabel.numberOfLines = 0;
}

@end
