//
//  StackTableViewCell.h
//  QQReader
//
//  Created by 邵邵函昊 on 16/7/12.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackModel.h"

@interface StackTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *categoryName;

@property (weak, nonatomic) IBOutlet UILabel *level3categoryName;

@property (weak, nonatomic) IBOutlet UIImageView *imgUrl;

@property (weak, nonatomic) IBOutlet UILabel *bookCount;

@property (weak, nonatomic) IBOutlet UIImageView *rightImg;

- (void)setModel:(StackModel *)model;

@end
