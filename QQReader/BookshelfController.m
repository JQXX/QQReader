//
//  BookshelfController.m
//  QQReader
//
//  Created by WangHao on 16/7/8.
//  Copyright © 2016年 qingmai.cn. All rights reserved.
//

float curContentOffsetY = 0;

#import "BookshelfController.h"
#import "BookshelfCollectionViewCell.h"
#import "BookshelfCollectionViewCell2.h"
#import "BookshelfCollectionReusableView.h"
#import "BookshelfCellModel.h"
#import "BookshelfGroupViewController.h"

#import "UIImageView+WebCache.h"




#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface BookshelfController ()<UICollectionViewDataSource,UICollectionViewDelegate>
//用来显示title的label
@property (strong,nonatomic) UILabel *label;
//数据源
@property (strong,nonatomic) NSMutableArray *dataSource;
//collectionView
@property (strong,nonatomic) UICollectionView *collectionView;
//判断排列模式
@property (assign,nonatomic) BOOL isShufengModel;
//下拉菜单
@property (strong,nonatomic) UIView *glideMenuView;
//下拉蒙板
@property (strong,nonatomic) UIView *maskView;
//alertsheet
@property (strong,nonatomic) UIAlertController *alert;



@end

@implementation BookshelfController


#pragma mark 调用方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customNavigationBar];
    [self createGlideMenuView];
    [self createDataSource];
    [self createCollectionView];
    [self createMaskView];
    [self createBtn];
    [self createAlertController];
 
}


#pragma mark 定制导航栏navigationbar
- (void)customNavigationBar{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bkg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //定制导航栏title
    _label = [[UILabel alloc] initWithFrame:CGRectMake(275/2, 0, 100,44)];
    _label.font = [UIFont systemFontOfSize:20];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.alpha = 0;
    _label.text = @"全部";
    
    self.navigationItem.titleView = _label;
    self.navigationItem.titleView.alpha = 0;
    
    
    //定制右btn
    UIImage *image1 = [[UIImage imageNamed:@"gengduo"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image1 style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    
}

- (void)rightBarButtonItemClick{
    static BOOL isClicked;
    
    if (!isClicked) {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"close"];
        _collectionView.userInteractionEnabled = NO;
        
        [self.view addSubview:_maskView];
        [self.view bringSubviewToFront:_glideMenuView];
       
    } else {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"gengduo"];
        _collectionView.userInteractionEnabled = YES;
        [_maskView removeFromSuperview];
        [self.view sendSubviewToBack:_glideMenuView];
    }
    
    isClicked = isClicked ? NO : YES;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _label.alpha = scrollView.contentOffset.y/175;
    curContentOffsetY = scrollView.contentOffset.y;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    _label.alpha = 0;
    if (curContentOffsetY != 0) {
        _collectionView.contentOffset = CGPointMake(0, curContentOffsetY);
        _label.alpha = curContentOffsetY / 175;
    }
}


#pragma mark 创建下滑菜单glidemenu
- (void)createGlideMenuView{
    _glideMenuView = [[UIView alloc]initWithFrame:CGRectMake(245, 0, 130, 200)];
    [self.view addSubview:_glideMenuView];
    _glideMenuView.backgroundColor = [UIColor whiteColor];
    
}


#pragma mark 创建btn
- (void)createBtn{
    NSArray *btnPicArr = @[@"bookshelf_menu_import",@"bookshelf_menu_category_list",@"bookshelf_menu_category_grid",@"bookshelf_menu_setting"];
    NSArray *btnNameArr = @[@" 导入书籍",@" 列表模式",@" 书架分组",@" 编辑书架"];
    
    for (int i=0; i<4; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0,i%4*50, 130, 50)];
        [btn setTitle:btnNameArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:btnPicArr[i]] forState:UIControlStateNormal];
        [_glideMenuView addSubview:btn];
        
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (int i = 0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,i%4*50 , 130, 1)];
        imageView.image = [UIImage imageNamed:@"found_line"];
        imageView.userInteractionEnabled = YES;
        [_glideMenuView addSubview:imageView];
    }

}

- (void)btnClick:(UIButton *)btn{
    
    //弹出alertsheet
    if (btn == _glideMenuView.subviews[0]) {
        
        [self presentViewController:_alert animated:YES completion:nil];
        
    }
    
    //切换书架模式
    if (btn == _glideMenuView.subviews[1]) {
        static BOOL isClicked;
        if (!isClicked) {
            
            _isShufengModel = YES;
            [btn setImage:[UIImage imageNamed:@"bookshelf_menu_grid"] forState:UIControlStateNormal];
            [btn setTitle:@" 书封模式" forState:UIControlStateNormal];
            
        }else{
            
            _isShufengModel = NO;
            [btn setImage:[UIImage imageNamed:@"bookshelf_menu_category_list"] forState:UIControlStateNormal];
            [btn setTitle:@" 列表模式" forState:UIControlStateNormal];
            
        }

        [_collectionView reloadData];
        _collectionView.userInteractionEnabled = YES;
        isClicked = isClicked ? NO : YES;
    }
    
    //书架分组
    if (btn == _glideMenuView.subviews[2]) {
        
        BookshelfGroupViewController *bgvc = [[BookshelfGroupViewController alloc]init];
        //修改返回按钮
        [self changeBackButtonItem];
        
        [self.navigationController pushViewController:bgvc animated:YES];
         
    }
    
    
    //编辑书架
    if (btn == _glideMenuView.subviews[3]) {
        
    }
    
    
    //收起下拉菜单
    [self rightBarButtonItemClick];

}

#pragma mark 修改backbutton
- (void)changeBackButtonItem
{
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title =@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
}


#pragma mark 创建蒙板视图
- (void)createMaskView{
    
    _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _maskView.backgroundColor = [UIColor grayColor];
    _maskView.alpha = 0.4;
    
 }

#pragma mark 创建UIAlertController
- (void)createAlertController{
    
    _alert = [UIAlertController alertControllerWithTitle:@"导入书籍" message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [_alert addAction:[UIAlertAction actionWithTitle:@"云书架" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [_alert addAction:[UIAlertAction actionWithTitle:@"Wi-Fi传书" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [_alert addAction:[UIAlertAction actionWithTitle:@"微云网盘" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [_alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
}


#pragma mark 创建dataSource
- (void)createDataSource{
    
    _dataSource = [[NSMutableArray alloc]init];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"defbooks" ofType:@"plist"]];
    
    for (NSString *str in dic) {
        NSArray *arr = dic[str];
        for (NSDictionary *d in arr) {
            BookshelfCellModel *m = [[BookshelfCellModel alloc]init];
            m.picName = d[@"coverURL"];
            NSMutableString *title = d[@"title"];
            if (title.length <= 7) {
                title = [NSMutableString stringWithFormat:@"%@\n",title];
            }
            m.titl = title;
            m.jindu = [NSString stringWithFormat:@"进度: 第%ld章",[d[@"finished"] integerValue]];
            m.zhangjie = [NSString stringWithFormat:@"章节: 第%ld章",[d[@"version"] integerValue]];
            m.gengxin = [NSString stringWithFormat:@"更新: 共%ld章",[d[@"drm"] integerValue]];
            [_dataSource addObject:m];
        }
    }
    
}


#pragma mark 创建collectionview
- (void)createCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-100) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"BookshelfCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BookshelfCollectionViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"BookshelfCollectionViewCell2" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BookshelfCollectionViewCell2"];
    [_collectionView registerNib:[UINib nibWithNibName:@"BookshelfCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookshelfCollectionReusableView"];
    [self.view addSubview:_collectionView];
    
}

#pragma mark 实现collectionview协议方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookshelfCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookshelfCollectionViewCell" forIndexPath:indexPath];
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:[_dataSource[indexPath.row] picName]]];
    cell.titleLabel.text = [_dataSource[indexPath.row] titl];
    cell.gengxinLabel.text = [_dataSource[indexPath.row] gengxin];
    
    
    BookshelfCollectionViewCell2 *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookshelfCollectionViewCell2" forIndexPath:indexPath];
    [cell2.img sd_setImageWithURL:[NSURL URLWithString:[_dataSource[indexPath.row] picName]]];
    cell2.titleLabel.text = [_dataSource[indexPath.row] titl];
    cell2.zhangjieLabel.text = [_dataSource[indexPath.row] zhangjie];
    cell2.jinduLabel.text = [_dataSource[indexPath.row] jindu];

    if (!_isShufengModel) {
        return cell;
    } else {
        return cell2;
    }
 }


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    BookshelfCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookshelfCollectionReusableView" forIndexPath:indexPath];
    
    reusableView.headBkg.image = [UIImage imageNamed:@"toolbar_bkg"];
    reusableView.yueduTime.text = @"10";
    reusableView.yuedushichang.text = @"本周阅读时长/分钟";
    reusableView.qindaoTime.text = @"本周已签1天";
//    reusableView.gift.image = [UIImage imageNamed:@"icon_gift"];
    
    return reusableView;
}


#pragma mark 实现flowlayout协议方法

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(375, 175);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    if (!_isShufengModel) {
        return CGSizeMake(100, 180);
    }
    else{
        return CGSizeMake(375,110);
    }

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (!_isShufengModel) {
        return UIEdgeInsetsMake(15 , 15, 10, 15);;
    }
    else{
        return UIEdgeInsetsMake(20, 0, 20, 0);
                          }

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
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
