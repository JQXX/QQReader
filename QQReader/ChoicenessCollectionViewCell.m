//
//  ChoicenessCollectionViewCell.m
//  QQReader
//
//  Created by 刘小云 on 16/7/11.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "ChoicenessCollectionViewCell.h"

@interface ChoicenessCollectionViewCell()<UIGestureRecognizerDelegate>

@end

@implementation ChoicenessCollectionViewCell
{
    UIPanGestureRecognizer *_pan;
    UILabel *label;
}

- (void)awakeFromNib {
    // Initialization code
//    self.backgroundColor = [UIColor redColor];
    
    _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(cellPan:)];
    [self addGestureRecognizer:_pan];
    _pan.delegate = self;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    label = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 375, 125)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"继续左滑删除\n不感兴趣的内容";
    label.textColor = [UIColor whiteColor];
    label.alpha = 1;
    label.backgroundColor = [UIColor colorWithRed:60 green:190 blue:255 alpha:0.5]; /// 6E82DC
    label.numberOfLines = 2;
    [self.contentView addSubview:label];
    [self.contentView sendSubviewToBack:label];
    
}

- (void)cellPan:(UIPanGestureRecognizer *)pan{
    static CGPoint startPoint;
    if (pan.state == UIGestureRecognizerStateBegan) {
        startPoint = [pan locationInView:self];
    }
    
    CGPoint currentPoint = [pan locationInView:self];
    CGFloat panDistance = currentPoint.x - startPoint.x;
    
    if (panDistance < 0) {
        label.alpha = 1;
//        label.backgroundColor = [UIColor colorWithRed:110 green:130 blue:220 alpha:0.5];
        
        self.contentView1.frame = CGRectMake(panDistance, self.contentView1.frame.origin.y, self.contentView1.frame.size.width, self.contentView1.frame.size.height);
        
        CGFloat colorRate = (fabs(panDistance) - self.contentView1.frame.size.width / 2) /  (self.contentView1.frame.size.width / 20);
//        if (fabs(panDistance) > self.contentView1.frame.size.width / 3) {
//            [UIView animateWithDuration:5 animations:^{
//                label.backgroundColor = [UIColor redColor];
//            } completion:^(BOOL finished) {
//            }];
            label.backgroundColor = [UIColor colorWithRed:colorRate  green:0 blue:0.5 alpha:0.5];
//        }
        
        if (pan.state == UIGestureRecognizerStateEnded) {
            if (fabs( panDistance ) > fabs(self.contentView1.frame.size.width/2 )) {
                [UIView animateWithDuration:0.15 animations:^{
                    
                    self.contentView1.frame = CGRectMake(-self.contentView1.frame.size.width, self.contentView1.frame.origin.y, self.contentView1.frame.size.width, self.contentView1.frame.size.height);
                } completion:^(BOOL finished) {
                    self.deleteCell();
//                    label.alpha = 0;
                }];
            }
            else{
                [UIView animateWithDuration:0.15 animations:^{
                    self.contentView1.frame = CGRectMake(0, self.contentView1.frame.origin.y, self.contentView1.frame.size.width, self.contentView1.frame.size.height);
                } completion:^(BOOL finished) {
//                    label.alpha = 0;
                }];
            }
            
        }}
    
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return YES;
    
    CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self];
    return fabs(translation.y) < fabs(translation.x);
}

@end
