//
//  NewCarCell.m
//  MyItem
//
//  Created by qianfeng007 on 15/12/15.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import "NewCarCell.h"
#import "UIView+Common.h"
#import <UIImageView+WebCache.h>
@implementation NewCarCell {
    UIImageView *_mainView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_saleLabel;
    UIButton *_button;
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
    _button = [[UIButton alloc] init];
    [self.contentView addSubview:_button];
}
- (void)setModel:(SerListModel *)model {
    _model = model;
    [_mainView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"account_download@2x"]];
    _titleLabel.text = model.name;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textColor = [UIColor grayColor];
    _priceLabel.text = [NSString stringWithFormat:@"￥：%@万",model.price];
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    _priceLabel.textColor = [UIColor orangeColor];
    _saleLabel.text = [NSString stringWithFormat:@"<%@>",model.newstitle];
    _saleLabel.adjustsFontSizeToFitWidth = YES;
    _saleLabel.textColor = [UIColor blueColor];
    [_button setBackgroundColor:[UIColor redColor]];
    _button.layer.cornerRadius = 5;
    [_button setTitle:@"点我看图" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonClick:(UIButton *)button {
    if (_delegate&&[_delegate respondsToSelector:@selector(sentSerid:withTitle:url:)]) {
        [_delegate sentSerid:_model.id withTitle:_model.name url:_model.imgurl];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftPadding = 10;
    CGFloat topPadding = 10;
    _mainView.frame = CGRectMake(leftPadding, topPadding, 100, 80);
    _titleLabel.frame = CGRectMake(maxX(_mainView)+leftPadding, topPadding, 200, 20);
    _priceLabel.frame = CGRectMake(maxX(_mainView)+leftPadding, maxY(_titleLabel)+5, 200, 30);
    _saleLabel.frame = CGRectMake(leftPadding, maxY(_mainView)+topPadding, 200, 20);
    _button.frame = CGRectMake(maxX(_mainView)+leftPadding, maxY(_priceLabel)+5, 80, 20);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
