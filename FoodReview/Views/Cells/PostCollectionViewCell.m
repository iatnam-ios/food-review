//
//  PostCollectionViewCell.m
//  FoodReview
//
//  Created by MTT on 23/05/2021.
//

#import "PostCollectionViewCell.h"

@interface PostCollectionViewCell()

@property (nonatomic, weak) id <PostCollectionCellDelegate> delegate;

@property (nonatomic) UIButton *likeButton;
@property (nonatomic) UIImageView *avatarImage;
@property (nonatomic) UILabel *nameLabel;

@end

@implementation PostCollectionViewCell

#pragma mark - UpdateUIAppearances

- (void)updateUIAppearances {
    self.layer.cornerRadius = 10.0;
    self.backgroundColor = UIColor.systemBackgroundColor;
    self.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textColor = UIColor.blackColor;
}

#pragma mark - Identifier

+ (NSString *)identifier {
    return @"reusePostCollectionViewCell";
}

#pragma mark - Set Up Views

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[UIButton alloc] init];
        _likeButton.tintColor = UIColor.redPinkColor;
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightLight];
        [_likeButton setTitleColor:UIColor.steelColor forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage systemImageNamed:@"heart"] forState: UIControlStateNormal];
        [_likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState: UIControlStateSelected];
        [_likeButton addTarget:self action:@selector(didPressLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        [_likeButton setTitle:@"900N" forState:UIControlStateNormal];
    }
    return _likeButton;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColor.labelColor;
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
        _nameLabel.text = @"taljnsejnvjnjdnvjnsdj";
    }
    return _nameLabel;
}

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [[UIImageView alloc] init];
        _avatarImage.layer.masksToBounds = YES;
        _avatarImage.layer.cornerRadius = 10.0;
    }
    return _avatarImage;
}

- (void)setupViews {
    [self.contentView addSubview:self.artwork];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.avatarImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.likeButton];
    
    [self.artwork mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(self.artwork.mas_width).multipliedBy(4.0 / 3.0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(6.0);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-6.0);
        make.top.equalTo(self.artwork.mas_bottom).offset(4.0);
        make.height.mas_equalTo(36.0);
    }];
    
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(6.0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-6.0);
        make.width.mas_equalTo(20.0);
        make.height.mas_equalTo(20.0);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatarImage.mas_trailing).offset(3.0);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-60.0);
        make.centerY.equalTo(self.avatarImage.mas_centerY);
        make.height.mas_equalTo(20.0);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing).offset(2.0);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-6.0);
        make.centerY.equalTo(self.avatarImage.mas_centerY);
    }];
}

#pragma mark - Configuration


#pragma mark - Actions

- (void)didPressLikeButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if ([self.delegate respondsToSelector: @selector(didPressLikeButton:)]) [self.delegate didPressLikeButton:self];
}


@end
