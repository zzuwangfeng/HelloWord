//
//  WKNewCarView.m
//  MyItem
//
//  Created by qianfeng007 on 15/12/15.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import "WKNewCarView.h"
#import <WebKit/WebKit.h>
@interface WKNewCarView ()<WKNavigationDelegate>
@property (nonatomic, copy) WKWebView *webView;
@property (nonatomic, copy) UIActivityIndicatorView *activityIndicatorView;


@end

@implementation WKNewCarView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}
- (void)createView {
    WKWebViewConfiguration *cofd = [[WKWebViewConfiguration alloc] init];
    
    cofd.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
    cofd.allowsInlineMediaPlayback = YES;
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:cofd];
    
    [self.view addSubview:_webView];
    _webView.navigationDelegate = self;
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    _activityIndicatorView.frame = CGRectMake(0, 0, 32, 32);
    _activityIndicatorView.center = self.view.center;
    
    [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [self.view addSubview:_activityIndicatorView];
   
    NSURL *url = [NSURL URLWithString:_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [_activityIndicatorView startAnimating];
    
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    [_activityIndicatorView stopAnimating];
    
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
