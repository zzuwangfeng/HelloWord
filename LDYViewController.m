//
//  LDYViewController.m
//  MyItem
//
//  Created by qianfeng007 on 15/12/14.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import "LDYViewController.h"
#import "LDYBaseViewController.h"
@interface LDYViewController ()

@end

@implementation LDYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self creatViewControlls];
}
- (void)creatViewControlls {
    
   NSArray *titles = @[@"HomeViewController",@"NewCarViewController",@"HotViewController"];
   NSArray *array = @[@[@"tabbar_subject",@"主页"],@[@"tabbar_limitfree",@"新车上市"],@[@"tabbar_rank",@"热榜"]];
    NSMutableArray *Views = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<titles.count; i++) {
      Class cls = NSClassFromString(titles[i]);
      LDYBaseViewController *bvc = [[cls alloc] init];
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bvc];
      NSString *NoImageName = [NSString stringWithFormat:@"%@@2x",array[i][0]];
      NSString *SeImageName = [NSString stringWithFormat:@"%@_press@2x",array[i][0]];
 
      UITabBarItem *items = [[UITabBarItem alloc] initWithTitle:array[i][1] image:[[UIImage imageNamed:NoImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:SeImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
       bvc.title = array[i][1];
       bvc.tabBarItem = items;
       [Views addObject:nav];
 }
    self.viewControllers = Views;
  
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
