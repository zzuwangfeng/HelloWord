//
//  NewCarCell.h
//  MyItem
//
//  Created by qianfeng007 on 15/12/15.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCarModel.h"


@protocol NewCarDelegate <NSObject>
- (void)sentSerid:(NSString *)Serid withTitle:(NSString *)title url:(NSString *)url;

@end

@interface NewCarCell : UITableViewCell
@property (nonatomic, strong) SerListModel *model;
@property (nonatomic, weak) id<NewCarDelegate> delegate;
@end
