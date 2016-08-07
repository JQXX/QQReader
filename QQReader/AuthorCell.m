//
//  AuthorCell.m
//  QQReader
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 Karen. All rights reserved.
//

#import "AuthorCell.h"
#import "Author.h"

@interface AuthorCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation AuthorCell

- (void)customCell:(Author *)model{
    self.titleLabel.text = model.titl;
    self.contentLabel.text = model.content;
    self.contentLabel.numberOfLines = 0;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
