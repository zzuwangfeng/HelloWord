//
//  FavoriteViewController.m
//  MyItem
//
//  Created by qianfeng007 on 15/12/17.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import "FavoriteViewController.h"
#import "FavoriteModel.h"
#import "DBManager.h"
#import "PicReadViewController.h"
@interface FavoriteViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    NSMutableArray *_dataSoucre;
}

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    self.navigationItem.title = @"我的收藏";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(buttonHandle:)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)buttonHandle:(UIBarButtonItem *)item {

    BOOL status = !_tableView.isEditing;
    [_tableView setEditing:status animated:YES];
    item.title = (status==YES) ? @"Done" : @"Edit";

}
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 40);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitle:@"删除所有收藏" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 15;
    btn.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:0.8];
    [btn addTarget:self action:@selector(deleteAllAction:) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableFooterView = btn;
    [self.view addSubview:_tableView];
}
- (void)deleteAllAction:(UIButton *)button {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"💀警告💀" message:@"您确定要删除所有收藏" preferredStyle:    UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[DBManager sharedManager] dropTable]) {
            [_dataSoucre removeAllObjects];
            [_tableView reloadData];
        }
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    [controller addAction:action];
    [controller addAction:action1];
    [self presentViewController:controller animated:YES completion:NULL];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSoucre.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [_dataSoucre[indexPath.row] title];
    cell.textLabel.textColor = [UIColor orangeColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteModel *model = _dataSoucre[indexPath.row];
    
    if ([model.recordType isEqualToString:@"header"]) {
        PicReadViewController *pic = [PicReadViewController new];
        pic.seriesid = model.favorityId;
        pic.hidesBottomBarWhenPushed = YES;
        pic.imageUrl = model.album_type;
        pic.titles = model.title;
        
        [self.navigationController pushViewController:pic animated:YES];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [[DBManager sharedManager] deleteValueWithFavorityId:[_dataSoucre[indexPath.row] favorityId]];
        [_dataSoucre removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)initData {
    _dataSoucre = [NSMutableArray arrayWithArray:[[DBManager sharedManager] readAllModels]];
    [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self initData];
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
