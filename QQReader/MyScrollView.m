//
//  MyScrollView.m
//  QQReader
//
//  Created by 邵邵函昊 on 16/7/14.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "MyScrollView.h"

@interface MyScrollView ()<UIGestureRecognizerDelegate>

@end

@implementation MyScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.panGestureRecognizer.delegate = self;
    }
    return self;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer locationInView:self].x > 20) {
        return YES;
    }
    
    return NO;
}

@end
