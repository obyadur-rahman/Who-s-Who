//
//  EmployeeCell.h
//  Who's Who
//
//  Created by Obyadur Rahman on 3/9/14.
//  Copyright (c) 2014 Sky World Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *__nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *__titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *__biographyLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;
@property (weak, nonatomic) IBOutlet UITextView *photoUrlTextView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

- (void)configCell;

@end
