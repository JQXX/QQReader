//
//  MonthlyModel.h
//  QQReader
//
//  Created by WangHao on 16/7/14.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthlyModel : NSObject
/** title */
@property (nonatomic, copy) NSString *title;
/** subTitle */
@property (nonatomic, copy) NSString *subtitle;
/** image */
@property (nonatomic, copy) NSString *imageName;

+ (instancetype) MonthlyWithDic:(NSDictionary *)dic;
@end
