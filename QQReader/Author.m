//
//  Author.m
//  QQReader
//
//  Created by WangHao on 16/7/28.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "Author.h"

@implementation Author
- (instancetype)initWithDic:(NSDictionary *)dic{
    self.content = dic[@"content"];
    self.href = dic[@"href"];
    self.titl = dic[@"title"];
    return self;
}
+ (instancetype)authorWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}
@end
