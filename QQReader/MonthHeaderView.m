//
//  MonthHeaderView.m
//  QQReader
//
//  Created by WangHao on 16/7/14.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "MonthHeaderView.h"

@implementation MonthHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.icon.layer.cornerRadius = 30;
    self.icon.layer.borderColor = [UIColor whiteColor].CGColor;
    self.icon.clipsToBounds = YES;
    self.icon.layer.borderWidth = 1;
}

@end
