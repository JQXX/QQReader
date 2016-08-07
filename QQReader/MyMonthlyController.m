//
//  MyMonthlyController.m
//  QQReader
//
//  Created by WangHao on 16/7/12.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "MyMonthlyController.h"
#import "MonthlyModel.h"

#define  SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define  SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface MyMonthlyController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
/** monthTableView */
@property (nonatomic, strong) UITableView *monthTable;
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;
/** shakeImage */
@property (nonatomic, strong) UIImageView *shakeImage;

@end

@implementation MyMonthlyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customBackground];
    [self createDataSource];
    [self createTableView];
    [self createShakeView];
}

- (void)createDataSource
{
    _dataSource = [[NSMutableArray alloc]init];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@"1个月 12 元"];
    [attr setAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} range:NSMakeRange(4, 2)];
    
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc]initWithString:@"3个月 30 元  省6元"];
    [attr1 setAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} range:NSMakeRange(4, 2)];
    [attr1 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(10, 3)];
    
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc]initWithString:@"6个月 60 元  省12元"];
    [attr2 setAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} range:NSMakeRange(4, 2)];
    [attr2 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(10, 4)];
    
    NSMutableAttributedString *attr3 = [[NSMutableAttributedString alloc]initWithString:@"12个月 118 元  省26元"];
    [attr3 setAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} range:NSMakeRange(5, 3)];
    [attr3 setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(12, 4)];
    NSArray *first = @[attr, attr1, attr2, attr3];
    
    NSArray *title = @[@"包月书免费在线读", @"专享活动", @"免费补签", @"8折购书", @"点亮图标", @"身份通用", @"更多特权即将开启"];
    NSArray *subTitle  = @[@"10万册包月图书在线免费看", @"充值送豪礼，还有肾7可以拿", @"每周一次免费补签，会员就要任性！", @"非包月书籍，享阅点消费8折", @"点亮电脑QQ面板图标", @"身份特权覆盖腾讯文学全平台", @"努力为您提供更好的服务"];
    NSArray *image = @[@"baoYue_Privi_first", @"baoYue_Privi_second", @"baoYue_Privi_third", @"baoYue_Privi_fourth", @"baoYue_Privi_fifth", @"baoYue_Privi_sixth", @"baoYue_Privi_more"];
    
    NSMutableArray *sec = [[NSMutableArray alloc]init];
    for (int i = 0; i < title.count; i++) {
        MonthlyModel *model = [[MonthlyModel alloc]init];
        model.title = title[i];
        model.subtitle = subTitle[i];
        model.imageName = image[i];
        
        [sec addObject:model];
    }
    
    [_dataSource addObject:first];
    [_dataSource addObject:sec];
}

#pragma mark - 创建tableView
- (void)createTableView
{
    _monthTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:_monthTable];
    _monthTable.delegate = self;
    _monthTable.dataSource = self;
    _monthTable.backgroundColor = [UIColor clearColor];
    
    UIView *header = [[[NSBundle mainBundle] loadNibNamed:@"MonthHeaderView" owner:nil options:nil] lastObject];
    _monthTable.tableHeaderView = header;
}

#pragma mark - 抖动按钮
- (void)createShakeView
{
    UIView *shakeView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, SCREEN_HEIGHT - 80, 60, 60)];
    shakeView.layer.cornerRadius = 30;
    shakeView.clipsToBounds = YES;
    [self.view addSubview:shakeView];
    
    _shakeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    _shakeImage.image = [UIImage imageNamed:@"notification_icon_inbulk_expiring"];
    [shakeView addSubview:_shakeImage];
    _shakeImage.backgroundColor = [UIColor redColor];
    
}

- (void)shakeTheImage
{
    [UIImageView animateWithDuration:0.1 animations:^{
        _shakeImage.transform = CGAffineTransformMakeRotation(M_PI / 15);
    } completion:^(BOOL finished) {
        [UIImageView animateWithDuration:0.07 animations:^{
            _shakeImage.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            
            [UIImageView animateWithDuration:0.07 animations:^{
                _shakeImage.transform = CGAffineTransformMakeRotation(-M_PI / 15);
            } completion:^(BOOL finished) {
                [UIImageView animateWithDuration:0.07 animations:^{
                    _shakeImage.transform = CGAffineTransformMakeScale(1.2, 1.2);
                } completion:^(BOOL finished) {
                    [UIImageView animateWithDuration:0.07 animations:^{
                        _shakeImage.transform = CGAffineTransformMakeRotation(M_PI / 15);
                    } completion:^(BOOL finished) {
                        
                        [UIImageView animateWithDuration:0.07 animations:^{
                            _shakeImage.transform = CGAffineTransformMakeScale(1.3, 1.3);
                        } completion:^(BOOL finished) {
                            [UIImageView animateWithDuration:0.07 animations:^{
                                _shakeImage.transform = CGAffineTransformMakeRotation(-M_PI / 15);
                            } completion:^(BOOL finished) {
                                
                                [UIImageView animateWithDuration:0.07 animations:^{
                                    _shakeImage.transform = CGAffineTransformMakeRotation(0);
                                } completion:^(BOOL finished) {
                                    [UIImageView animateWithDuration:0.07 animations:^{
                                        _shakeImage.transform = CGAffineTransformMakeScale(1, 1);
                                    } completion:^(BOOL finished) {
                                        
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
    
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
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell1"];
        }
        
        cell.textLabel.attributedText = _dataSource[0][indexPath.row];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
        label.textColor = [UIColor whiteColor];
        label.layer.backgroundColor = [UIColor orangeColor].CGColor;
        label.layer.cornerRadius = 15;
        label.textAlignment = NSTextAlignmentCenter;
        switch (indexPath.row) {
            case 0:
                label.text = @"12元";
                break;
            case 1:
                label.text = @"30元";
                break;
            case 2:
                label.text = @"60元";
                break;
            case 3:
                label.text = @"118元";
                break;
                
            default:
                break;
        }
        
        cell.accessoryView = label;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    MonthlyModel *m = _dataSource[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:m.imageName];
    cell.textLabel.text = m.title;
    cell.detailTextLabel.text = m.subtitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    header.textColor = [UIColor grayColor];
    header.font = [UIFont systemFontOfSize:15];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if (section == 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        label.text = @"包月会员如何关闭";
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:12];
        [header addSubview:label];
        header.text = @"包月套餐";
    } else {
        header.text = @"包月特权";
    }
    return header;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 100;
    }
    
    return 44;
}

#pragma mark - 界面定制
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bkg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(shakeTheImage) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantPast];
}

#pragma mark - 背景模糊
- (void)customBackground
{
    UIImageView * imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baoyue_bg"]];
    imageview.userInteractionEnabled = YES;
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:imageview];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height);
    effectview.alpha = 0.8;
    [imageview addSubview:effectview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
