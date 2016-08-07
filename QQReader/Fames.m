//
//  Fames.m
//  QQReader
//
//  Created by WangHao on 16/7/28.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "Fames.h"
@implementation Fames
- (instancetype)initWithDic:(NSDictionary *)dic{
    self.name = dic[@"name"];
    self.img = dic[@"img"];
    self.valuee = dic[@"value"];
    self.label = dic[@"label"];
    self.intro = dic[@"intro"];
    return self;
}

+ (instancetype)famesWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}

@end
