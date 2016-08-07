//
//  MyAccountController.m
//  QQReader
//
//  Created by WangHao on 16/7/12.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "MyAccountController.h"

#define  SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define  SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface MyAccountController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
/** tableView */
@property (nonatomic, strong) UITableView *accountTable;
@end

@implementation MyAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDataSource];
    [self createTableView];
}

- (void)createDataSource
{
    _dataSource = [[NSMutableArray alloc]init];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@"余额：0 阅点"];
    [attr setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor] , NSFontAttributeName : [UIFont systemFontOfSize:15]} range:NSMakeRange(3, 1)];
    
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc]initWithString:@"阅卷：211 付费时优先扣除"];
    [attr1 setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName : [UIFont systemFontOfSize:15]} range:NSMakeRange(3, 3)];
    [attr1 setAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor] , NSFontAttributeName : [UIFont systemFontOfSize:12]} range:NSMakeRange(6, 8)];
    
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc]initWithString:@"我的包月：未开通"];
    [attr2 setAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:12]} range:NSMakeRange(5, 3)];
    
    NSArray *first = @[attr, attr1];
    NSArray *sec = @[attr2];
    NSArray *third = @[@"我的购买", @"消费记录", @"我的笔记", @"我的收藏"];
    
    [_dataSource addObject:first];
    [_dataSource addObject:sec];
    [_dataSource addObject:third];
}

- (void)createTableView
{
    _accountTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_accountTable];
    _accountTable.delegate = self;
    _accountTable.dataSource = self;
    _accountTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section < 2) {
        cell.textLabel.attributedText = _dataSource[indexPath.section][indexPath.row];
    } else {
        cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
    }
    
    
    UILabel * accessory = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 25)];
    accessory.layer.borderWidth = 1;
    accessory.layer.cornerRadius = 4;
    accessory.layer.borderColor = [UIColor orangeColor].CGColor;
    accessory.textColor = [UIColor orangeColor];
    accessory.textAlignment = NSTextAlignmentCenter;
    if (indexPath.section == 0 && indexPath.row == 0) {
        accessory.text = @"充值";
        cell.accessoryView = accessory;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        accessory.text = @"开通";
        cell.accessoryView = accessory;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    
    self.navigationController.navigationBar.translucent = NO;
}


@end
