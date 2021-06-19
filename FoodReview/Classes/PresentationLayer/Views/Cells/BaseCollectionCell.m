//
//  BaseCollectionCell.m
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#import "BaseCollectionCell.h"

@implementation BaseCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
        [self setupViews];
    }
    
    return self;
}

#pragma mark - Initialize

- (void)initialize {
    self.layer.masksToBounds = YES;
    self.backgroundColor = UIColor.greenColor;
    [self updateUIAppearances];
}

#pragma mark - UpdateUIAppearances

- (void)updateUIAppearances {
    
}

#pragma mark - UpdateLayoutConstraints

- (void)updateLayoutConstraints {
    
}

#pragma mark - SetupViews

//- (UILabel *)captionLabel {
//    if (!_captionLabel) {
//        _captionLabel = [[UILabel alloc] init];
//        _captionLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        _captionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
//        _captionLabel.textColor = UIColor.redPinkColor;
//    }
//    return _captionLabel;
//}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UIView *)backingView {
    if (!_backingView) {
        _backingView = [[UIView alloc] init];
        _backingView.layer.cornerRadius = 4.5;
        _backingView.layer.masksToBounds = YES;
    }
    return _backingView;
}

- (UIImageView *)artwork {
    if (!_artwork) {
        _artwork = [[UIImageView alloc] init];
        _artwork.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _artwork;
}

- (void)setupViews {
    
}


@end
