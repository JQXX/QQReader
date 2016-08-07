//
//  HeaderView.h
//  QQReader
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 Karen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Author;

@interface HeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *hrefView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
- (void)customHeaderView:(Author *)model;
- (void)changeSize;
@end
