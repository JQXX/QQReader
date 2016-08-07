//
//  FenLeiTableViewCell.h
//  QQReader
//
//  Created by 邵邵函昊 on 16/7/14.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FenLeiModel.h"

@interface FenLeiTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cover;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *author;

@property (weak, nonatomic) IBOutlet UILabel *lpushname;

@property (weak, nonatomic) IBOutlet UILabel *hotNum;

- (void)setModel:(FenLeiModel *)model;

@end
