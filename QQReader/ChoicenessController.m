//
//  ChoicenessController.m
//  QQReader
//
//  Created by WangHao on 16/7/8.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

#import "ChoicenessController.h"
#import "ChoicenessCollectionViewCell.h"
#import "ChoicenessReusableView.h"
#import "ChoicenessModel.h"

#import "UIImageView+WebCache.h"
#import "WebViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "MMProgressHUD.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ChoicenessController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIImageView *_imageView;
    NSString *_leftBarUrl;
    
    NSMutableArray *_dataSource;
    UICollectionView *_collectionView;
    UILabel *_titLabel;
    UIRefreshControl *_refreshControl;
    BOOL _isLoading;
    
}

@end

@implementation ChoicenessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self customNavigationBar];
    [self createDataSource];
    [self createCollectionView];
    [self createRefreshControl];
    [self anlasize];
}

#pragma mark - 导航条定制
- (void)customNavigationBar{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bkg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;

    
    _titLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    _titLabel.textColor = [UIColor whiteColor];
    _titLabel.text = @"精选";
    self.navigationItem.titleView = _titLabel;
    _titLabel.alpha = 0;
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    [_imageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"11"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    [_imageView addGestureRecognizer:tap];
    [self httpAnaysize];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_imageView];
    
    UIImage *image = [[UIImage imageNamed:@"search_icon_night"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(searchBarClick:)];
}

//搜索按钮
- (void)searchBarClick:(UIButton *)btn{
//    NSLog(@"dd");
}

//左边点击事件
- (void)onTap:(UITapGestureRecognizer *)tap{
    self.hidesBottomBarWhenPushed = YES;
    WebViewController *web = [[WebViewController alloc]init];
    web.num = 1;
    web.url = _leftBarUrl;
    [self.navigationController pushViewController:web animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _titLabel.alpha = scrollView.contentOffset.y / 210;
}

// http://wfqqreader.3g.qq.com/cover/topic/newad_67786051_1467972374573.gif
//同步解析左边按钮
- (void)httpAnaysize{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ios.reader.qq.com/v5_9/queryads?adids=102797"]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [[NSURLSessionDataTask alloc]init];
    task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data==nil) {
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *ads = dic[@"ads"];
        NSDictionary *di = ads[@"102797"];
        NSArray *arr = di[@"adList"];
        NSDictionary *d = arr[0];
        _leftBarUrl = d[@"url"];
        
//        NSString *imageUrl = d[@"imageUrl"];
//        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:@"http://wfqqreader.3g.qq.com/cover/topic/newad_67786051_1467972374573.gif"]];
    }];
    [task resume];
}


#pragma mark - 创建数据源
- (void)createDataSource{
    _dataSource = [[NSMutableArray alloc]init];
}

#pragma mark - 创建下拉刷新
- (void)createRefreshControl{
    _refreshControl = [[UIRefreshControl alloc]init];
    _refreshControl.tintColor = [UIColor grayColor];
    _refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [_collectionView addSubview:_refreshControl];
    
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)refresh:(UIRefreshControl*)refreshCotrl{
    if (_isLoading == NO) {
        _isLoading = YES;
        [self anlasize];
    }
}

//刷新结束
- (void)loadEnd{
    _isLoading = NO;
    [_refreshControl endRefreshing];
}

#pragma mark - 创建上拉加载
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    float tableViewHeight = _collectionView.frame.size.height;
    float tableViewContentHeight = _collectionView.contentSize.height;
    float tableViewOffY = _collectionView.contentOffset.y;
    
    
    
    if (!_isLoading) {//如果正在刷新 则不处理
        if (tableViewOffY>0) {//如果 往上拉表格视图  偏移量>0 执行上拉加载
            if (tableViewHeight +tableViewOffY>tableViewContentHeight+100) {
                //计算  当手指滑动 到表格 最底端并且再滑动100 时 执行上拉加载更多
                [self anlasize];
            }
        }
    }
}

#pragma mark - 解析
- (void)anlasize{
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
//    [MMProgressHUD showDeterminateProgressWithTitle:@"" status:@"正在加载数据"];
    static int i = 7;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"http://ios.reader.qq.com/v5_9/queryintro?bid=24344%d&sex=1&expRecFlag=1&cataRecFlag=1&origin=102580&authorRecFlag=1",--i] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *cataRec = dic[@"cataRec"];
        NSArray *arr = cataRec[@"cataRecList"];
        for (NSDictionary *d in arr) {
            ChoicenessModel *model = [[ChoicenessModel alloc]init];
            //            model.imgView
            //            model.link
            model.author = d[@"author"];
            model.yijiName = d[@"cat3Info"];
            model.erjiName = d[@"categoryName"];
            model.jieshao = d[@"intro"];
            model.pingfen = d[@"mark"];
            model.title = d[@"title"];
            [_dataSource addObject:model];
        }
        [_collectionView reloadData];
        
        //解析完成，调用刷新结束方法，恢复到初始状态
        [self loadEnd];
//        [MMProgressHUD dismissWithSuccess:@"请求数据成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [MMProgressHUD dismissWithError:@"请求数据失败"];
    }];
}

#pragma mark - 创建collectionView
- (void)createCollectionView{
    UICollectionViewFlowLayout *cfl = [[UICollectionViewFlowLayout alloc]init];
    cfl.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:cfl];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ChoicenessCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"choicenessCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"ChoicenessReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"choicenessReusableView"];
}

#pragma mark - collection 协议方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}

//定制cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChoicenessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"choicenessCell" forIndexPath:indexPath];
    
    cell.deleteCell = ^(){
        [_dataSource removeObjectAtIndex:indexPath.row];
//        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
//        [_collectionView.subviews[indexPath.row] removeFromSuperview];
        [_collectionView reloadData];
    };
    
    ChoicenessModel *model = _dataSource[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.jieshaoLabel.text = model.jieshao;
    cell.authorLabel.text = model.author;
    cell.yiTitleLabel.text = model.yijiName;
    cell.erTitleLabel.text = model.erjiName;
    cell.markLabel.text = [NSString stringWithFormat:@"%@分",model.pingfen];
    
    return cell;
}

//cell头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ChoicenessReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"choicenessReusableView" forIndexPath:indexPath];
    
    reusableView.btnClick = ^(){
        self.hidesBottomBarWhenPushed = YES;
        WebViewController *web = [[WebViewController alloc]init];
        web.num = 2;
        web.url = @"http://iyuedu.qq.com/ios/newuser/newUser.html?type=2&net_type=1&nosid=1&uin=997195963&version=qqreader_5.9.0.0188_iphone&sex=1&qimei=db1ccb11-3de6-41d0-9877-2993711143dc&themeid=2000&loginType=1&platform=ioswp&sid=1467941972151178&jailbreak=0&ua=iPhone8%2C1-iPhone%20OS9.3.2&skey=M7BhFi8Lu8&text_type=1";
        [self.navigationController pushViewController:web animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    };
    
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, 125);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 260);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 0, 0, 0);
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
