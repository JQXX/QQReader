//
//  ChoicenessReusableView.h
//  QQReader
//
//  Created by 刘小云 on 16/7/12.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoicenessReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIButton *xinshouBtn;

@property (weak, nonatomic) IBOutlet UIImageView *xinshouImgView;

@property (weak, nonatomic) IBOutlet UILabel *xinshouLabel;

@property (weak, nonatomic) IBOutlet UILabel *lingquLabel;

@property (copy)void(^btnClick)();

@end
