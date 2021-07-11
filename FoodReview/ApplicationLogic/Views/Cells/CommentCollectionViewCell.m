//
//  CommentCollectionViewCell.m
//  FoodReview
//
//  Created by MTT on 09/07/2021.
//

#import "CommentCollectionViewCell.h"

@interface CommentCollectionViewCell()

@property (nonatomic) UILabel *contentLabel;
@property (nonatomic) UILabel *timeLabel;

@end

@implementation CommentCollectionViewCell

#pragma mark - UpdateUIAppearances

- (void)updateUIAppearances {
    self.layer.cornerRadius = 10.0;
    self.backgroundColor = UIColor.systemBackgroundColor;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textColor = UIColor.blackColor;
    
    self.artwork.layer.masksToBounds = YES;
    self.artwork.layer.cornerRadius = 25.0;
}

#pragma mark - Identifier

+ (NSString *)identifier {
    return @"reuseCommentCollectionViewCell";
}

#pragma mark - Set Up Views

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = UIColor.labelColor;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    }
    return _contentLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColor.labelColor;
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
    }
    return _timeLabel;
}

- (void)setupViews {
    [self.contentView addSubview:self.artwork];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.artwork mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(4.0);
        make.leading.equalTo(self.contentView.mas_leading).offset(4.0);
        make.height.width.mas_equalTo(50.0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(4.0);
        make.leading.equalTo(self.artwork.mas_trailing).offset(6.0);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-4.0);
        make.height.mas_equalTo(22.0);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(2.0);
        make.leading.equalTo(self.titleLabel.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-4.0);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(2.0);
        make.leading.equalTo(self.titleLabel.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-4.0);
        make.height.mas_equalTo(20.0);
    }];
}

#pragma mark - Configuration

-(void)configCellWithComment:(Comment *)comment {
    [self.artwork sd_setImageWithURL:[NSURL URLWithString:comment.userAvatar] placeholderImage:[UIImage imageNamed:@"avatar-default"]];
    self.titleLabel.text = comment.userName;
    self.contentLabel.text = comment.content;
    self.timeLabel.text = comment.createdDate.description;
}

@end
