//
//  PicReadViewController.m
//  MyItem
//
//  Created by qianfeng007 on 15/12/15.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import "PicReadViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>
#import "ReadPicModel.h"
#import <UIImageView+WebCache.h>
#import "SkimViewController.h"
#import "JWCache.h"
#import "NSString+Common.h"
#import <MBProgressHUD.h>
#import "FavoriteModel.h"
#import "DBManager.h"
#import "UIView+Common.h"
@interface PicReadViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIPopoverPresentationControllerDelegate>
{
    NSMutableArray *_dataSource;
    UICollectionView *_collectionView;
    NSString *_url;
    NSInteger _typeid;
}


@end

@implementation PicReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc] init];
    self.navigationItem.title = _titles;
    [self createbuttons];

    _typeid = 1;
    [self createViews];
}
- (void)createbuttons {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonClick:)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"UC_collection"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"heart_red@2x"] forState:UIControlStateSelected];
    button.alpha = 0.7;
    [button addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([[DBManager sharedManager] isExistAppForAppId:_seriesid recordType:@"header"]) {
        button.selected = YES;
    }
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[item,item1];
}
- (void)startAction:(UIButton *)button {
    if (button.selected) {
        [button setSelected:NO];
        [[DBManager sharedManager] deleteValueWithFavorityId:_seriesid];
    } else {
        [button setSelected:YES];
        FavoriteModel *model = [FavoriteModel new];
        model.favorityId = _seriesid;
        model.title = _titles;
        model.album_type = _imageUrl;
        [[DBManager sharedManager] insertModel:model recordType:@"header"];
    }
}
#pragma mark --pop
- (void)buttonClick:(UIBarButtonItem *)item {
    UIViewController *controller = [UIViewController new];
    controller.view.backgroundColor = [UIColor blackColor];
    controller.preferredContentSize = CGSizeMake(70, 150);
    controller.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *presentController = controller.popoverPresentationController;
    presentController.barButtonItem = item;
    presentController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    presentController.delegate = self;
    
    NSArray *array = @[@"外观",@"中控",@"座椅",@"图解",@"测评",@"其他"];
    for (int i = 0; i<array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 25*i, 70, 25);
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        button.tag = 100+i;
     [button addTarget:self action:@selector(detailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [controller.view addSubview:button];
    }
 
    [self presentViewController:controller animated:YES completion:NULL];
}
- (void)detailButtonClick:(UIButton *)button {
    NSInteger tag = button.tag-100;
    switch (tag) {
        case 0:
            _typeid = 1;
            break;
        case 1:
            _typeid = 10;
            break;
        case 2:
            _typeid = 3;
            break;
        case 3:
            _typeid = 12;
            break;
        case 4:
            _typeid = 13;
            break;
        case 5:
            _typeid = 14;
            break;
        default:
            break;
    }
    [_dataSource removeAllObjects];
    [_collectionView reloadData];
    [self LoadDataFromNet:NO];
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

#pragma mark --Net
- (void)LoadDataFromNet:(BOOL)isMore {
    
    NSInteger page = 1;
    if (isMore) {
        if (_dataSource.count%20 != 0) {
            return;
        
        }
        page = _dataSource.count/20 + 1;
        
    }
    _url = [NSString stringWithFormat:@"http://baojia.qichecdn.com/priceapi3.9.16/services/cars/piclist?typeid=%ld&colorid=0&colortype=0&seriesid=%@&specid=0&pagesize=20&pageindex=%lu",(long)_typeid,_seriesid,page];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData *cacheData = [JWCache objectForKey:MD5Hash(_url)];
    if (cacheData) {
        ReadPicModel *model = [[ReadPicModel alloc] initWithData:cacheData error:nil];
        if (isMore) {
            [_dataSource addObjectsFromArray:model.result.list];
        }else {
            [_dataSource removeAllObjects];
            [_collectionView reloadData];
            _dataSource = model.result.list;
        }
        [_collectionView reloadData];
        // 隐藏 loading 提示框
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
        return;
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ReadPicModel *model = [[ReadPicModel alloc] initWithData:responseObject error:nil];
        if (isMore) {
      [_dataSource addObjectsFromArray:model.result.list];
        }else {
            [_dataSource removeAllObjects];
            [_collectionView reloadData];
            _dataSource = model.result.list;
        }
        [_collectionView reloadData];
         isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [JWCache setObject:responseObject forKey:MD5Hash(_url)];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         isMore?[_collectionView.mj_footer endRefreshing]:[_collectionView.mj_header endRefreshing];
    }];
    
}

- (void)createViews {
  
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[self createLayout]];
    _collectionView.backgroundColor = [UIColor grayColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    [self.view addSubview:_collectionView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      
        [self LoadDataFromNet:NO];
    }];
    
    _collectionView.mj_header = header;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter  footerWithRefreshingBlock:^{
       
        [self LoadDataFromNet:YES];
    }];
    _collectionView.mj_footer = footer;
    [_collectionView.mj_header beginRefreshing];
    
    
}
- (UICollectionViewLayout *)createLayout {
    
    CGFloat width = (self.view.frame.size.width - 60)/3;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    
    layout.itemSize = CGSizeMake(width, width*0.8);
    layout.sectionInset = UIEdgeInsetsMake(0,10,0,10);
    
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width*2/3);
    return layout;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    SpecModel *model= _dataSource[indexPath.row];
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:cell.frame];
    [view sd_setImageWithURL:[NSURL URLWithString:model.smallpic] placeholderImage:nil];
    cell.backgroundView = view;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerId" forIndexPath:indexPath];
    UIImageView *imageView = nil;
    NSArray *array = view.subviews;
    
    
    if (array.count != 0) {
        imageView = array[0];
    } else {
        imageView = [[UIImageView alloc] init];
        CGSize size = view.frame.size;
        imageView.frame = CGRectMake(0, 0, size.width, size.height-20);
        [imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:nil];
        [view addSubview:imageView];
    }
    return view;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
    SkimViewController *cv = [[SkimViewController alloc] initWithImageNames:_dataSource index:indexPath.row];
    cv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cv animated:YES];
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
