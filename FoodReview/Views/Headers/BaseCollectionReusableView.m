//
//  BaseCollectionReusableView.m
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#import "BaseCollectionReusableView.h"

@implementation BaseCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
        [self setupViews];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateUIAppearances];
    [self updateLayoutConstraints];
}

+ (NSString *)identifier {
    return @"reuseBaseCollectionReusableView";
}

#pragma mark - Initialize

- (void)initialize {
    
}

#pragma mark - UpdateUIAppearances

- (void)updateUIAppearances {
    
    self.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.titleLabel.font = UIFont.titleBold;
    self.seeAllButton.titleLabel.font = UIFont.titleRegular;
}

#pragma mark - UpdateLayoutConstraints

- (void)updateLayoutConstraints {
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(20.0);
    }];
    
    [self.seeAllButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).offset(-20.0);
    }];
    
    [self.addButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).offset(-20.0);
    }];
}

#pragma mark - SetupViews

- (UIView *)backingView {
    if (!_backingView) {
        _backingView = [[UIView alloc] init];
        _backingView.layer.cornerRadius = 4.5;
        _backingView.layer.masksToBounds = YES;
    }
    return _backingView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
    }
    return _titleLabel;
}

- (UIButton *)seeAllButton {
    if (!_seeAllButton) {
        _seeAllButton = [[UIButton alloc]init];
        [_seeAllButton setTitle:@"Xem thêm" forState:UIControlStateNormal];
        [_seeAllButton setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
        [_seeAllButton addTarget:self action:@selector(didPressSeeAll:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeAllButton;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        _addButton.tintColor = UIColor.redPinkColor;
        _addButton.hidden = YES;
        UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:20.0 weight:UIImageSymbolWeightLight];
        UIImage *image = [UIImage systemImageNamed:@"plus" withConfiguration:configuration];
        [_addButton setImage:image forState:UIControlStateNormal];
        [_addButton setTitle:nil forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(didPressAdd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIButton *)sortButton {
    if (!_sortButton) {
        _sortButton = [[UIButton alloc] init];
        _sortButton.layer.borderWidth = 1.0;
        _sortButton.layer.cornerRadius = 4.5;
        _sortButton.layer.masksToBounds = YES;
        [_sortButton setTitle:@"Sort" forState:UIControlStateNormal];
        [_sortButton setImage:[UIImage imageNamed:@"icon_sort"] forState: UIControlStateNormal];
        [_sortButton addTarget:self action:@selector(didPressSort:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortButton;
}

- (void)setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.seeAllButton];
    [self addSubview:self.addButton];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading).offset(20.0);
    }];

    [self.seeAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-20.0);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-20.0);
    }];
}

#pragma mark - Actions

- (void)didPressSeeAll:(UIButton *)sender {
    if ([self.delegate respondsToSelector: @selector(didPressSeeAll:)]) {
        [self.delegate didPressSeeAll: self];
    }
}

- (void)didPressAdd:(UIButton *)sender {
    if ([self.delegate respondsToSelector: @selector(didPressAdd:)]) {
        [self.delegate didPressAdd: self];
    }
}

- (void)didPressSort:(UIButton *)sender {
    if ([self.delegate respondsToSelector: @selector(didPressSort:)]) {
        [self.delegate didPressSort: self];
    }
}

@end
