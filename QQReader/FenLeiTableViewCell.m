//
//  FenLeiTableViewCell.m
//  QQReader
//
//  Created by 邵邵函昊 on 16/7/14.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "FenLeiTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation FenLeiTableViewCell


- (void)setModel:(FenLeiModel *)model{
    self.author.text = model.author;
    self.title.text = model.title;
    self.lpushname.text = model.lpushname;
    self.hotNum.text = model.hotNum;
    NSURL *url = [NSURL URLWithString:model.cover];
    [self.cover sd_setImageWithURL:url placeholderImage:nil];
    
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
