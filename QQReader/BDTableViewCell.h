//
//  BDTableViewCell.h
//  QQReader
//
//  Created by LcyLHt on 16/7/14.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *secBtn;
@property (weak, nonatomic) IBOutlet UIButton *firBtn;
@property (weak, nonatomic) IBOutlet UIButton *thBtn;

@property (weak, nonatomic) IBOutlet UILabel *secLabel;
@property (weak, nonatomic) IBOutlet UILabel *firLabel;
@property (weak, nonatomic) IBOutlet UILabel *thLabel;



@end
