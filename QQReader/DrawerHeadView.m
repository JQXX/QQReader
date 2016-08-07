//
//  DrawerHeadView.m
//  QQReader
//
//  Created by WangHao on 16/7/15.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "DrawerHeadView.h"

@implementation DrawerHeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.icon.layer.cornerRadius = 35;
    self.icon.clipsToBounds = YES;
}

@end
