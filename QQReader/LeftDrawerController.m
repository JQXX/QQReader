//
//  LeftDrawerController.m
//  QQReader
//
//  Created by WangHao on 16/7/11.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "LeftDrawerController.h"
#import "RESideMenu.h"
#import "TabbarController.h"
#import "MyAccountController.h"
#import "MyMonthlyController.h"
#import "MyNewsController.h"
#import "HistoryController.h"
#import "MyGeneViewController.h"

#define  SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define  SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface LeftDrawerController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *drawerTable;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation LeftDrawerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDataSource];
    [self customDrawerView];
    [self createTableView];
    [self createSetting];
}

#pragma mark - 创建数据源
- (void)createDataSource
{
    _dataSource = [[NSMutableArray alloc]init];
    
    NSArray *titleArr = @[@"我的账户", @"我的包月", @"我的消息", @"浏览历史", @"我的基因"];
    NSArray *imageArr = @[@"pc_icon_money", @"pc_icon_monthly", @"pc_icon_reading_info", @"pc_history", @"wx_icon"];
    
    [_dataSource addObject:titleArr];
    [_dataSource addObject:imageArr];
}

#pragma mark - 自定义抽屉视图
- (void)customDrawerView
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pc_bg"]];
}

#pragma mark - 创建Setting
- (void)createSetting
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT - 50, 60, 30)];
    [btn setTitle:@"  设置" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"pc_icon_set"] forState:UIControlStateNormal];
    
    
    [self.view addSubview:btn];
}

#pragma mark - 创建tableview
- (void)createTableView
{
    _drawerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 10 * 3 - 130, SCREEN_WIDTH / 10 * 7, SCREEN_HEIGHT / 10 *7) style:UITableViewStylePlain];
    _drawerTable.delegate = self;
    _drawerTable.dataSource = self;
    _drawerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _drawerTable.backgroundColor = [UIColor clearColor];
    _drawerTable.rowHeight = 50;
    [self.view addSubview:_drawerTable];
    
    UIView *header = [[[NSBundle mainBundle] loadNibNamed:@"DrawerHeadView" owner:nil options:nil] lastObject];
    _drawerTable.tableHeaderView = header;
}

#pragma mark - tableView 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[0] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:[_dataSource[1] objectAtIndex:indexPath.row]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [_dataSource[0] objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@"我的账户  充值享好礼"];
        [attr setAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor], NSFontAttributeName : [UIFont systemFontOfSize:12]} range:NSMakeRange(6, 5)];
        cell.textLabel.attributedText = attr;
    }
    
    UILabel * accessory = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    accessory.layer.borderWidth = 0.5;
    accessory.layer.cornerRadius = 4;
    accessory.layer.borderColor = [UIColor whiteColor].CGColor;
    accessory.textColor = [UIColor whiteColor];
    accessory.font = [UIFont systemFontOfSize:13];
    accessory.textAlignment = NSTextAlignmentCenter;
    if (indexPath.section == 0 && indexPath.row == 0) {
        accessory.text = @"充值";
        cell.accessoryView = accessory;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        accessory.text = @"开通";
        cell.accessoryView = accessory;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UINavigationController *nc = self.tab.viewControllers[self.tab.selectedIndex];
    [self.sideMenuViewController setContentViewController:self.tab animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
    switch (indexPath.row) {
        case 0:
        {
            MyAccountController *mc = [[MyAccountController alloc]init];
            [nc pushViewController:mc animated:YES];
            break;
            
        } case 1: {
            MyMonthlyController *mc = [[MyMonthlyController alloc]init];
            [nc pushViewController:mc animated:YES];
            break;
            
        } case 2: {
            MyNewsController *mc = [[MyNewsController alloc]init];
            [nc pushViewController:mc animated:YES];
            break;
            
        } case 3: {
            HistoryController *mc = [[HistoryController alloc]init];
            [nc pushViewController:mc animated:YES];
            break;
            
        } case 4: {
            MyGeneViewController *mc = [[MyGeneViewController alloc]init];
            [nc pushViewController:mc animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
