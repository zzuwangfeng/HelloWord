//
//  DetailCell.m
//  MyItem
//
//  Created by qianfeng007 on 15/12/15.
//  Copyright © 2015年 李东亚. All rights reserved.
//

#import "DetailCell.h"
#import "UIView+Common.h"
#import <UIImageView+WebCache.h>
@implementation DetailCell {
    UIImageView *_mainView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_saleLabel;
    UILabel *_levenameLabel;
}

- (void)awakeFromNib {
    
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
     _levenameLabel = [UILabel new];
    [self.contentView addSubview:_levenameLabel];
}
- (void)setModel:(SeriesModel *)model {
    [_mainView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"account_download@2x"]];
    _titleLabel.text = model.name;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textColor = [UIColor grayColor];
    
    _priceLabel.text = [NSString stringWithFormat:@"￥：%@万",model.price];
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    _levenameLabel.adjustsFontSizeToFitWidth = YES;
    _priceLabel.textColor = [UIColor redColor];
    _saleLabel.text = [NSString stringWithFormat:@"已经出售%@辆",model.salestate];
    _saleLabel.adjustsFontSizeToFitWidth = YES;
    _saleLabel.font = [UIFont systemFontOfSize:13];
    _levenameLabel.text = [NSString stringWithFormat:@"(%@)",model.levelname];
    _levenameLabel.font = [UIFont systemFontOfSize:13];
    _levenameLabel.textColor = [UIColor orangeColor];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftPadding = 10;
    CGFloat topPadding = 10;
    _mainView.frame = CGRectMake(leftPadding, topPadding, 80, 70);
    _titleLabel.frame = CGRectMake(maxX(_mainView)+10, topPadding, 100, 20);
    _levenameLabel.frame = CGRectMake(maxX(_titleLabel), topPadding, 80, 30);
    _priceLabel.frame = CGRectMake(maxX(_mainView)+10, maxY(_levenameLabel), 110, 30);
    _saleLabel.frame = CGRectMake(maxX(_priceLabel)+10, maxY(_levenameLabel)+10, 90, 30);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
