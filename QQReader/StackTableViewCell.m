//
//  StackTableViewCell.m
//  QQReader
//
//  Created by 邵邵函昊 on 16/7/12.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "StackTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation StackTableViewCell


- (void)setModel:(StackModel *)model{
    self.categoryName.text = model.categoryName;
    self.level3categoryName.text = model.level3categoryName;
    self.bookCount.text = model.bookCount;
    NSURL *url = [NSURL URLWithString:model.imgUrl];
    [self.imgUrl sd_setImageWithURL:url placeholderImage:nil];
    self.rightImg.image = [UIImage imageNamed:@"batch_fold"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
