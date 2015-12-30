//
//  MoreViewController.m
//  MyItem
//
//  Created by qianfeng007 on 15/12/16.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import "MoreViewController.h"
#import "WKNewCarView.h"
#import "JWCache.h"
#import <SDImageCache.h>
#import "FavoriteViewController.h"
@interface MoreViewController () {
    NSTimer *_timer;
    UIButton *touchButton;
    BOOL _isShow;
    NSMutableArray *_buttonArray;
    CGRect curframe;
    CGFloat _height;
    NSTimer *_timer1;
    NSInteger _index;
    NSMutableArray *_pointsArray;
    
}

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更多";
    self.view.backgroundColor = [UIColor yellowColor];
    [self creatbuttons];
    [self createTiemer];
    [self createTimer1];
    _pointsArray = [[NSMutableArray alloc] init];
    _index = 1;
    _height = self.view.frame.size.height/2+50;
    
}
- (void)createTiemer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeFrame) userInfo:nil repeats:YES];
    [self fireTimer];
}
- (void)fireTimer {
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)stopTimer {
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)creatbuttons {
    touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    touchButton.frame = CGRectMake(CGRectGetMidX(self.view.frame)-50, 90, 100, 100);
    [touchButton setTitle:@"Touch me" forState:UIControlStateNormal];
    [touchButton setBackgroundColor:[UIColor greenColor]];
    touchButton.layer.cornerRadius = 50;
    [touchButton addTarget:self action:@selector(tocuhAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:touchButton];
    
    NSArray *titles = @[@"二手车",@"保值率",@"团购",@"分期购车",@"我的收藏",@"清除缓存"];
    CGFloat buttonWidth = 72.f;
    CGFloat buttonHeight = 72.f;
    CGFloat margin = (CGRectGetWidth(self.view.frame)- buttonWidth*3)/4.0;
    NSInteger i = 0;
    _buttonArray = [NSMutableArray array];
    CGFloat screenHeight = CGRectGetHeight(self.view.frame);
    for (NSString *title in titles) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((i%3+1)*margin +i%3*buttonWidth, screenHeight +i/3*(buttonHeight + 20), buttonWidth, buttonHeight);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:title forState:UIControlStateNormal];
        button.layer.cornerRadius = 36;
        [button setBackgroundColor:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i + 100;
        [_buttonArray addObject:button];
        [self.view addSubview:button];
        i++;
    }
 
}
- (void)changeFrame {
        [UIView animateWithDuration:0.7 animations:^{
            touchButton.transform = CGAffineTransformScale(touchButton.transform, 1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.7 animations:^{
                touchButton.transform = CGAffineTransformScale(touchButton.transform, 0.8, 0.8);
            } completion:^(BOOL finished) {
                if (_isShow) {
                    [self stopTimer];
                }
            }];
        }];
}
- (void)showMenuAnimation:(BOOL)animation {
    int i = 0;
    for (UIButton *button in _buttonArray) {
        if (animation) {
            [UIView animateWithDuration:0.7 delay:0.01*(i++) usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
                CGRect rect = button.frame;
                rect.origin.y -= _height;
                button.frame = rect;
                UIButton *btn= (UIButton *)[self.view viewWithTag:103];
                curframe = btn.frame;
            } completion:^(BOOL finished) {
                
            }];
        } else {
            CGRect rect = button.frame;
            rect.origin.y -= _height;
            button.frame = rect;
        }
    }
    _isShow = !_isShow;
}

- (void)hiddenMenuAnimation:(BOOL)animation {
    UIButton *btn= (UIButton *)[self.view viewWithTag:103];
    btn.frame = curframe;
    int k = 0;
    int totalsBtn = (int)_buttonArray.count;
    for (int i = totalsBtn; i > 0; i--) {
        UIButton *btn = (UIButton *)_buttonArray[i-1];
        if (animation) {
            [UIView animateWithDuration:0.7 delay:0.01*(k++)  usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
                CGRect rect = btn.frame;
                rect.origin.y += _height;
                btn.frame = rect;
            } completion:^(BOOL finished) {
                
            }];
        } else {
            CGRect rect = btn.frame;
            rect.origin.y += _height;
            btn.frame = rect;
        }
    }
    _isShow = !_isShow;
}
- (void)tocuhAction:(UIButton *)button {
    if (!_isShow) {
        [self showMenuAnimation:YES];
        return;
    }
    
    [self hiddenMenuAnimation:YES];
}
- (void)buttonClick:(UIButton *)button {
    [UIView animateWithDuration:0.2 animations:^{
        button.transform = CGAffineTransformMakeScale(2, 2);
        button.alpha = 0.3;
    } completion:^(BOOL finished) {
        button.transform = CGAffineTransformMakeScale(1, 1);
        button.alpha = 1;
        [self hiddenMenuAnimation:NO];
    }];
    WKNewCarView *View = [WKNewCarView new];
    NSUInteger tag = button.tag - 100;
    switch (tag) {
       case 0:
      View.URL = @"http://hezuo.m.che168.com/china/list/";
      [self.navigationController pushViewController:View animated:YES];
            break;
       case 1:
      View.URL = @"http://m.che168.com/KeepValue/seriesvaluekeep.html";
     [self.navigationController pushViewController:View animated:YES];
            break;
       case 2:
    View.URL = @"http://super.m.autohome.com.cn/?pvareaid=2011577";
    [self.navigationController pushViewController:View animated:YES];
            break;
       case 3:
    View.URL = @"http://j.autohome.com.cn/loan/loan/doubleele!warmupMIndex";
       [self.navigationController pushViewController:View animated:YES];
            break;
       case 4:{
           [self.navigationController pushViewController:[FavoriteViewController new] animated:YES];
        }
            break;
       case 5: {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"您有%.1fMb缓存，确定清理吗？", [JWCache getCacheLength]] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [JWCache resetCache];
                [[SDImageCache sharedImageCache] cleanDisk];
                [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
                UIAlertController *controller1 = [UIAlertController alertControllerWithTitle:nil message:@"☺️清理完成☺️" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:NULL];
                [controller1 addAction:action2];
                [self presentViewController:controller1 animated:YES completion:NULL];

            }];
            [controller addAction:action1];
            [self presentViewController:controller animated:YES completion:^{
             
            }];
        }
    
        default:
            break;
    }
  
}

#pragma mark - 移动

- (void)createTimer1 {
     _timer1 = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(walking) userInfo:nil repeats:YES];
}
- (void)fireTimer1 {
    [_timer1 setFireDate:[NSDate distantPast]];
}
- (void)stopTimer1 {
    [_timer1 setFireDate:[NSDate distantFuture]];
}
- (void)walking {
    UIButton *btn = (UIButton *)[self.view viewWithTag:103];
   
    if (_index >= _pointsArray.count) {
        [self stopTimer1];
        return;
    }
    CGPoint currentPoint = [[_pointsArray objectAtIndex:_index] CGPointValue];
    btn.center = currentPoint;
    _index++;
    if (CGRectIntersectsRect(btn.frame, touchButton.frame)){
        [self stopTimer1];
        btn.frame = curframe;
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_isShow) {
    
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.view];
        [_pointsArray addObject:[NSValue valueWithCGPoint:point]];
    }
 
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self fireTimer1];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    if ([_timer1 isValid]) {
        [_timer1 invalidate];
        _timer1 = nil;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fireTimer];
    [self fireTimer1];
//    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeFrame) userInfo:nil repeats:YES];
//    _timer1 = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(walking) userInfo:nil repeats:YES];
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
