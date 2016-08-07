//
//  ZTTableViewCell.h
//  QQReader
//
//  Created by LcyLHt on 16/7/15.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIImageView *urlImageView;

@end
