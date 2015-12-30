//
//  HotViewCell.m
//  MyItem
//
//  Created by qianfeng007 on 15/12/15.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import "HotViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIView+Common.h"
@implementation HotViewCell {
    UIImageView *_mainView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_saleLabel;
}

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self coustom];
    }
    return self;
}

- (void)coustom {
    _mainView =[[UIImageView alloc] init];
    [self.contentView addSubview:_mainView];
    _titleLabel = [UILabel new];
    [self.contentView addSubview:_titleLabel];
    _priceLabel = [UILabel new];
    [self.contentView addSubview:_priceLabel];
    _saleLabel = [UILabel new];
    [self.contentView addSubview:_saleLabel];
}
- (void)setModel:(SeriModel *)model {
    _model = model;
    [_mainView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"account_download@2x"]];
    _titleLabel.text = model.name;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textColor = [UIColor grayColor];
    _priceLabel.text = [NSString stringWithFormat:@"￥：%@万",model.price];
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    _priceLabel.textColor = [UIColor redColor];
    _saleLabel.text = [NSString stringWithFormat:@"近三十天全国4s店询价订单：%@笔",model.ordercount];
    _saleLabel.adjustsFontSizeToFitWidth = YES;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftPadding = 10;
    CGFloat topPadding = 10;
    _mainView.frame = CGRectMake(leftPadding, topPadding, 100, 80);
    _titleLabel.frame = CGRectMake(maxX(_mainView)+leftPadding, topPadding, 200, 20);
    _priceLabel.frame = CGRectMake(maxX(_mainView)+leftPadding, maxY(_titleLabel)+topPadding, 200, 20);
    _saleLabel.frame = CGRectMake(maxX(_mainView)+leftPadding, maxY(_priceLabel)+topPadding, 200, 20);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
