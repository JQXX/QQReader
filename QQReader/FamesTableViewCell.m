//
//  FamesTableViewCell.m
//  QQReader
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 Karen. All rights reserved.
//

#import "FamesTableViewCell.h"
#import "Fames.h"
#import "UIImageView+WebCache.h"

@interface FamesTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *labelView;
@end

@implementation FamesTableViewCell
- (void)customCell:(Fames *)model
{
    self.introLabel.text = model.intro;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.nameLabel.text = model.name;
    self.labelView.image = [UIImage imageNamed:[NSString stringWithFormat:@"标签%@",model.label]];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
