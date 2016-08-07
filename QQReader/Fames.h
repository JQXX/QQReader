//
//  Fames.h
//  QQReader
//
//  Created by WangHao on 16/7/28.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fames : NSObject
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *img;
@property (strong,nonatomic) NSString *valuee;
@property (strong,nonatomic) NSString *label;
@property (strong,nonatomic) NSString *intro;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)famesWithDic:(NSDictionary *)dic;
@end
