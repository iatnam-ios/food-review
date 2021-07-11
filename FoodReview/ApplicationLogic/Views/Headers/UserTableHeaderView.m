//
//  UserTableHeaderView.m
//  FoodReview
//
//  Created by MTT on 01/07/2021.
//

#import "UserTableHeaderView.h"

@interface UserTableHeaderView()

@property (nonatomic) UIImageView *avatar;
@property (nonatomic) UILabel *displayNameLabel;
@property (nonatomic) UILabel *userNameLabel;
@property (nonatomic) UILabel *descLabel;
@property (nonatomic) UILabel *reviewsLabel;
@property (nonatomic) UILabel *followersLabel;
@property (nonatomic) UILabel *followedsLabel;

@property (nonatomic) UIButton *detailButton;

@end

@implementation UserTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self initialize];
        [self setupViews];
    }
    return self;
}

#pragma mark - Initialize

- (void)initialize {
    
}

#pragma mark - SetupViews

- (UIImageView *)avatar {
    if (_avatar == nil) {
        _avatar = [[UIImageView alloc] init];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = 40.0;
    }
    return _avatar;
}

- (UILabel *)displayNameLabel {
    if (_displayNameLabel == nil) {
        _displayNameLabel = [[UILabel alloc] init];
        _displayNameLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _displayNameLabel.textColor = UIColor.blackColor;
    }
    return _displayNameLabel;
}

- (UILabel *)userNameLabel {
    if (_userNameLabel == nil) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
        _userNameLabel.textColor = UIColor.steelColor;
    }
    return _userNameLabel;
}

- (UILabel *)descLabel {
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
        _descLabel.textColor = UIColor.labelColor;
    }
    return _descLabel;
}

- (UILabel *)reviewsLabel {
    if (_reviewsLabel == nil) {
        _reviewsLabel = [[UILabel alloc] init];
        _reviewsLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
        _reviewsLabel.textColor = UIColor.steelColor;
        _reviewsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _reviewsLabel;
}

- (UILabel *)followersLabel {
    if (_followersLabel == nil) {
        _followersLabel = [[UILabel alloc] init];
        _followersLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
        _followersLabel.textColor = UIColor.steelColor;
        _followersLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followersLabel;
}

- (UILabel *)followedsLabel {
    if (_followedsLabel == nil) {
        _followedsLabel = [[UILabel alloc] init];
        _followedsLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
        _followedsLabel.textColor = UIColor.steelColor;
        _followedsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _followedsLabel;
}

- (UIButton *)followButton {
    if (_followButton == nil) {
        _followButton = [[UIButton alloc] init];
        _followButton.hidden = YES;
        _followButton.layer.masksToBounds = YES;
        _followButton.layer.cornerRadius = 4.0;
        [_followButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_followButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_followButton setTitle:@"Theo dõi" forState:UIControlStateNormal];
        [_followButton setTitle:@"Đã theo dõi" forState:UIControlStateSelected];
        [_followButton setBackgroundImage:[Common imageFromColor:UIColor.orangeColor] forState:UIControlStateNormal];
        [_followButton setBackgroundImage:[Common imageFromColor:UIColor.steelColor] forState:UIControlStateSelected];
        [_followButton addTarget:self action:@selector(didPressFollowButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followButton;
}

- (UIButton *)detailButton {
    if (_detailButton == nil) {
        _detailButton = [[UIButton alloc] init];
        _detailButton.hidden = YES;
        _detailButton.layer.masksToBounds = YES;
        _detailButton.layer.cornerRadius = 4.0;
        [_detailButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_detailButton setTitle:@"Chi tiết" forState:UIControlStateNormal];
        [_detailButton setBackgroundImage:[Common imageFromColor:UIColor.orangeColor] forState:UIControlStateNormal];
        [_detailButton addTarget:self action:@selector(didPressDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}


- (void)setupViews {
    [self addSubview:self.avatar];
    [self addSubview:self.displayNameLabel];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.followButton];
    [self addSubview:self.detailButton];
    [self addSubview:self.reviewsLabel];
    [self addSubview:self.followersLabel];
    [self addSubview:self.followedsLabel];
    [self addSubview:self.descLabel];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10.0);
        make.leading.equalTo(self.mas_leading).offset(14.0);
        make.width.height.mas_equalTo(80.0);
    }];
    
    [self.displayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10.0);
        make.leading.equalTo(self.avatar.mas_trailing).offset(14.0);
        make.trailing.equalTo(self.mas_trailing).offset(-14.0);
        make.height.mas_equalTo(24.0);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.displayNameLabel.mas_bottom).offset(2.0);
        make.leading.equalTo(self.avatar.mas_trailing).offset(14.0);
        make.trailing.equalTo(self.mas_trailing).offset(-14.0);
        make.height.mas_equalTo(24.0);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(4.0);
        make.leading.equalTo(self.avatar.mas_trailing).offset(14.0);
        make.trailing.equalTo(self.mas_trailing).offset(-44.0);
        make.height.mas_equalTo(26.0);
    }];
    
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(4.0);
        make.leading.equalTo(self.avatar.mas_trailing).offset(14.0);
        make.trailing.equalTo(self.mas_trailing).offset(-44.0);
        make.height.mas_equalTo(26.0);
    }];
    
    [self.reviewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar.mas_bottom).offset(20.0);
        make.trailing.equalTo(self.followersLabel.mas_leading).offset(-10.0);
        make.height.mas_equalTo(44.0);
    }];
    
    [self.followersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar.mas_bottom).offset(20.0);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(44.0);
    }];
    
    [self.followedsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar.mas_bottom).offset(20.0);
        make.leading.equalTo(self.followersLabel.mas_trailing).offset(10.0);
        make.height.mas_equalTo(44.0);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reviewsLabel.mas_bottom).offset(20.0);
        make.leading.equalTo(self.mas_leading).offset(14.0);
        make.trailing.equalTo(self.mas_trailing).offset(-14.0);
        make.height.mas_equalTo(24.0);
    }];
}

-(void)didPressFollowButton:(UIButton *)sender {
    [self.delegate didPressFollowButton:sender];
}

-(void)didPressDetailButton:(UIButton *)sender {
    [self.delegate didPressDetailButton:sender];
}

- (void)setup:(User *)user {
    self.followButton.hidden = NO;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:user.profileImageUrl] placeholderImage:[UIImage imageNamed:@"avatar-default"]];
    self.displayNameLabel.text = user.displayName;
    self.userNameLabel.text = [NSString stringWithFormat:@"@%@", user.userName];
    self.descLabel.text = user.userDescription;
}

- (void)setupForCurrentUser:(User *)user {
    self.detailButton.hidden = NO;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:user.profileImageUrl] placeholderImage:[UIImage imageNamed:@"avatar-default"]];
    self.displayNameLabel.text = user.displayName;
    self.userNameLabel.text = [NSString stringWithFormat:@"@%@", user.userName];
    self.descLabel.text = user.userDescription;
}

- (void)setReviewLabel:(NSInteger)value {
    self.reviewsLabel.text = [NSString stringWithFormat:@"%ld Review", (long)value];
}

- (void)setFollowerLabel:(NSInteger)value {
    self.followersLabel.text = [NSString stringWithFormat:@"%ld Follower", (long)value];
}

- (void)setFollowedLabel:(NSInteger)value {
    self.followedsLabel.text = [NSString stringWithFormat:@"%ld Followed", (long)value];
}

@end
