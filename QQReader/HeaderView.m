//
//  HeaderView.m
//  QQReader
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 Karen. All rights reserved.
//

#import "HeaderView.h"
#import "UIImageView+WebCache.h"
#import "Author.h"

@implementation HeaderView

- (void)customHeaderView:(Author *)model
{
    [self.hrefView sd_setImageWithURL:[NSURL URLWithString:model.href]];
    self.hrefView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.titleLabel.text = model.titl;
    self.contentLabel.text = model.content;

    [self.backgroundView sd_setImageWithURL:[NSURL URLWithString:model.href]];
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)changeSize{
    self.backgroundView.frame = self.bounds;
    self.effectView.frame = self.bounds;
    
    if (self.frame.size.height*80/264 < 42) {
        self.hrefView.frame = CGRectMake(147+(40-42/2), 89-(40-self.frame.size.height*80/264/2)*2.3, 42, 42);
    } else if (self.frame.size.height*80/264 > 80){
        self.hrefView.frame = CGRectMake(147, 89-(40-self.frame.size.height*80/264/2)*2.3, 80, 80);
    } else {
        self.hrefView.frame = CGRectMake(147+(40-self.frame.size.height*80/264/2), 89-(40-self.frame.size.height*80/264/2)*2.3, self.frame.size.height*80/264, self.frame.size.height*80/264);
    }
    
    self.contentLabel.frame = CGRectMake(8, 89+117-(40-self.frame.size.height*80/264/2)*2.3, 359, 47);
    self.titleLabel.frame = CGRectMake(8, 89+88-(40-self.frame.size.height*80/264/2)*2.3, 359, 21);
    self.hrefView.layer.cornerRadius = self.hrefView.frame.size.height/2;
    self.hrefView.layer.borderWidth = self.hrefView.frame.size.height/40+1;
}
@end
