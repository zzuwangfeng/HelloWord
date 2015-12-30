//
//  LDYBaseViewController.m
//  MyItem
//
//  Created by qianfeng007 on 15/12/14.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import "LDYBaseViewController.h"
#import "MoreViewController.h"
@interface LDYBaseViewController ()

@end

@implementation LDYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatButtonItems];
}
- (void)creatButtonItems {
//    initWithImage:[[UIImage imageNamed:@"more_2@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick:)];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
    [button setBackgroundImage:[[UIImage imageNamed:@"more_2@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)buttonClick:(UIButton *)button {
    MoreViewController *more = [MoreViewController new];
    more.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:more animated:YES];
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
