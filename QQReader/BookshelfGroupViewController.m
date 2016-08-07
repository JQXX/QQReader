//
//  BookshelfGroupViewController.m
//  QQReader
//
//  Created by L-QP on 16/7/14.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "BookshelfGroupViewController.h"
#import "GroupTableViewCell.h"


@interface BookshelfGroupViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataSource;
    UITableView *_tableView;
    
}

@end

@implementation BookshelfGroupViewController

#pragma mark 定制navigationbar
- (void)customNavigationbar{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    //定制title
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(275/2, 0, 100, 44)];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"书架分组";
    
    self.navigationItem.titleView = label;
    
    //定制rightbutton
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)rightButtonClick:(UIButton *)btn{
    
    
}

#pragma mark 创建数据源
- (void)createDataSource{
    _dataSource = [[NSMutableArray alloc]init];
    NSArray *fenzuArr = @[@"全部",@"在线",@"未分组"];
    
    [_dataSource addObject:fenzuArr];
}


#pragma mark 创建tableView
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"GroupTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    [_tableView reloadData];
}

#pragma mark 实现协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataSource[0] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[GroupTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.titleLabel.text = _dataSource[0][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2 ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customNavigationbar];
    [self createDataSource];
    [self createTableView];
    
    
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
