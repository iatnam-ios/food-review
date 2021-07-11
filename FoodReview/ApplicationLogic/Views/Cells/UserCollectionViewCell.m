//
//  UserCollectionViewCell.m
//  FoodReview
//
//  Created by MTT on 11/07/2021.
//

#import "UserCollectionViewCell.h"

@interface UserCollectionViewCell()

@property (nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation UserCollectionViewCell

#pragma mark - UpdateUIAppearances

- (void)updateUIAppearances {
    self.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.titleLabel.numberOfLines = 1;
    
    self.artwork.layer.cornerRadius = 30.0;
    self.artwork.clipsToBounds = YES;
}

#pragma mark - Identifier

+ (NSString *)identifier {
    return @"reuseUserCollectionViewCell";
}

#pragma mark - Set Up Views

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = UIColor.steelColor;
        _subtitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    }
    return _subtitleLabel;
}

- (void)setupViews {
    [self.contentView addSubview:self.artwork];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    
    [self.artwork mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(self.artwork.mas_height);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.artwork.mas_trailing).offset(10.0);
        make.trailing.equalTo(self.contentView.mas_trailing);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(24.0);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.artwork.mas_trailing).offset(10.0);
        make.trailing.equalTo(self.contentView.mas_trailing);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4.0);
        make.height.mas_equalTo(24.0);
    }];
}

#pragma mark - Configuration

- (void)configueWithUser:(User *)user {
    [self.artwork sd_setImageWithURL:[NSURL URLWithString:user.profileImageUrl] placeholderImage:[UIImage imageNamed:@"avatar-default"]];
    self.titleLabel.text = user.displayName;
    self.subtitleLabel.text = [NSString stringWithFormat:@"@%@", user.userName];
}

@end
