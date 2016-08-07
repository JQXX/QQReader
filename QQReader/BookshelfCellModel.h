//
//  BookshelfCellModel.h
//  QQReader
//
//  Created by L-QP on 16/7/11.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookshelfCellModel : NSObject
//图片
@property (copy,nonatomic) NSString *picName;
//标题
@property (copy,nonatomic) NSString *titl;
//进度
@property (copy,nonatomic) NSString *jindu;
//章节
@property (copy,nonatomic) NSString *zhangjie;
//更新
@property (copy,nonatomic) NSString *gengxin;




@end
