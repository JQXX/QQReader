//
//  BookshelfCollectionReusableView.m
//  QQReader
//
//  Created by L-QP on 16/7/11.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "BookshelfCollectionReusableView.h"

@implementation BookshelfCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
    
    self.liJi.layer.cornerRadius = 15;
    self.liJi.layer.borderWidth = 1;
    self.liJi.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
