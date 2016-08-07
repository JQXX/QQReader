 //
//  BookshelfCollectionReusableView.h
//  QQReader
//
//  Created by L-QP on 16/7/11.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookshelfCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *headBkg;

@property (weak, nonatomic) IBOutlet UIImageView *gift;

@property (weak, nonatomic) IBOutlet UILabel *yueduTime;

@property (weak, nonatomic) IBOutlet UILabel *yuedushichang;

@property (weak, nonatomic) IBOutlet UILabel *qindaoTime;

@property (weak, nonatomic) IBOutlet UIImageView *bolang;

@property (weak, nonatomic) IBOutlet UIButton *liJi;

@end
