//
//  HallList.m
//  QQReader
//
//  Created by WangHao on 16/7/28.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "HallList.h"

@interface HallList ()
@property (strong,nonatomic) NSString *identifier;
@property (strong,nonatomic) NSString *name;
@end

@implementation HallList
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self.identifier = dic[@"id"];
    self.name = dic[@"name"];
    return self;
}

+ (instancetype)hallListWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
@end
