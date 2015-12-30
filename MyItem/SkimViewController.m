//  SkimViewController.m
//  MyItem
//  Created by qianfeng007 on 15/12/15.
//  Copyright © 2015年 李东亚. All rights reserved.

#import "SkimViewController.h"
#import "ReadPicModel.h"
#import <UIImageView+WebCache.h>
@interface SkimViewController ()<UIScrollViewDelegate> {
    NSInteger _index;
    NSArray *_imageUrl;
    NSMutableArray *_imageViews;
    UIScrollView *_scrollView;
    BOOL canscroll;
}

@end

@implementation SkimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self createScrollView];
    
    [self createScrollImageViews];
}
- (instancetype)initWithImageNames:(NSArray *)imageUrl index:(NSInteger)index {
    self = [super init];
    if (self) {
        _imageUrl = imageUrl;
        _index = index;
        self.navigationItem.title = [NSString stringWithFormat:@"%lu/%lu",index+1,imageUrl.count];
    }
    return self;
}
- (void)createScrollView {
    self.automaticallyAdjustsScrollViewInsets = YES;
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.frame;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.scrollEnabled = canscroll;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
}
- (void)createScrollImageViews
{
    _imageViews = [[NSMutableArray alloc] init];
    
    CGSize size = _scrollView.frame.size;

    for (NSUInteger i=0; i<3; i++) {
        UIImageView *view = [[UIImageView alloc] init];
        view.frame = CGRectMake(i*size.width, 0, size.width, size.height);
  
        view.backgroundColor = [UIColor blackColor];
        view.contentMode = UIViewContentModeScaleAspectFit;

        view.tag = (_index+i-1+_imageUrl.count)%_imageUrl.count;
  
        [self setImageToView:view];
        
        if (i != 1) {
   
            [_scrollView addSubview:view];
        } else {
   
            UIScrollView *sv = [[UIScrollView alloc] init];
            sv.frame = view.frame;
            view.frame = CGRectMake(0, 0, size.width, size.height);
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
            [view addGestureRecognizer:singleTap];
   
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
            doubleTap.numberOfTapsRequired = 2;
            [view addGestureRecognizer:doubleTap];

            [singleTap requireGestureRecognizerToFail:doubleTap];
            [sv addSubview:view];

            sv.minimumZoomScale = 0.2;
            sv.maximumZoomScale = 2.0;

            sv.delegate = self;
            
            [_scrollView addSubview:sv];
        }
 
        [_imageViews addObject:view];
    }

    _scrollView.contentSize = CGSizeMake(3*size.width, 0);

    _scrollView.contentOffset = CGPointMake(size.width, 0);
}
- (BOOL)prefersStatusBarHidden {
    return self.navigationController.navigationBarHidden;
}

- (void)tapGestureHandle:(UITapGestureRecognizer *)tgr {
    if (tgr.numberOfTapsRequired == 1) {
        
        _scrollView.scrollEnabled = !canscroll;
        BOOL flag = !self.navigationController.navigationBarHidden;
        [self.navigationController setNavigationBarHidden:flag animated:YES];
        [self setNeedsStatusBarAppearanceUpdate];
        canscroll = !canscroll;
    } else if (tgr.numberOfTapsRequired == 2) {

        UIScrollView *sv = (UIScrollView *)[tgr.view superview];
        CGFloat maximumScale = sv.maximumZoomScale;
        if (sv.zoomScale != 1.0) {
            [sv setZoomScale:1.0 animated:YES];
        } else {
            [sv setZoomScale:maximumScale animated:YES];
        }
    }
}
- (void)setImageToView:(UIImageView *)view {
    SpecModel *model = _imageUrl[view.tag];
    [view sd_setImageWithURL:[NSURL URLWithString:model.smallpic] placeholderImage:nil];
}
- (void)cycleReuse {
    int flag = 0;
    CGSize size = _scrollView.frame.size;
    CGFloat offsetX = _scrollView.contentOffset.x;
    if (offsetX == 2*size.width) {
   
        flag = 1;
    } else if (offsetX == 0) {
   
        flag = -1;
    } else {
        return;
    }

    for (UIImageView *view in _imageViews) {
        view.tag = (view.tag+flag+_imageUrl.count)%_imageUrl.count;
        [self setImageToView:view];
    }
  
    _scrollView.contentOffset = CGPointMake(size.width, 0);
   [self refreshTitle];
    UIScrollView *sv = (UIScrollView *)[_imageViews[1] superview];
    sv.zoomScale = 1.0;
}
- (void)refreshTitle {
    self.navigationItem.title = [NSString stringWithFormat:@"%lu/%lu", [_imageViews[1] tag]+1, _imageUrl.count];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self cycleReuse];
}
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageViews[1];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    if (scale < 0.5) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
