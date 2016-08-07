//
//  ChoicenessCollectionViewCell.h
//  QQReader
//
//  Created by 刘小云 on 16/7/11.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChoicenessCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *jieshaoLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (weak, nonatomic) IBOutlet UILabel *yiTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *erTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *markLabel;

@property (weak, nonatomic) IBOutlet UIView *contentView1;

@property (copy)void(^deleteCell)();
@property (weak, nonatomic) IBOutlet UIImageView *authorImgView;
@property (weak, nonatomic) IBOutlet UIImageView *freeImgView;

@end
