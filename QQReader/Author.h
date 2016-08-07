//
//  Author.h
//  QQReader
//
//  Created by WangHao on 16/7/28.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Author : NSObject
@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) NSString *titl;
@property (strong,nonatomic) NSString *href;
- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)authorWithDic:(NSDictionary *)dic;
@end
