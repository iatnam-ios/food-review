//
//  RatingView.m
//  FoodReview
//
//  Created by MTT on 30/06/2021.
//

#import "RatingView.h"

@implementation RatingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
        [self initialize];
    }
    
    return self;
}

#pragma mark - Initialize

- (void)initialize {
    self.rate = 0;
}

#pragma mark - SetupViews

- (UILabel *)ratingName {
    if (!_ratingName) {
        _ratingName = [[UILabel alloc] init];
        _ratingName.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    }
    return _ratingName;
}

- (HCSStarRatingView *)ratingView {
    if (!_ratingView) {
        _ratingView = [[HCSStarRatingView alloc] init];
        _ratingView.maximumValue = 5;
        _ratingView.minimumValue = 1;
        _ratingView.value = 0;
        _ratingView.tintColor = [UIColor redColor];
        [_ratingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _ratingView;
}

- (UILabel *)rating {
    if (!_rating) {
        _rating = [[UILabel alloc] init];
        _rating.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _rating.textAlignment = NSTextAlignmentRight;
    }
    return _rating;
}

- (void)setupViews {
    [self addSubview:self.ratingName];
    [self addSubview:self.ratingView];
    [self addSubview:self.rating];
    
    [self.ratingName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self);
        make.width.mas_equalTo(78.0);
    }];
    
    [self.ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(4.0);
        make.bottom.equalTo(self.mas_bottom).offset(-4.0);
        make.leading.equalTo(self.ratingName.mas_trailing).offset(4.0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
    }];
    
    [self.rating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(self);
        make.leading.equalTo(self.ratingView.mas_trailing).offset(4.0);
    }];
}

-(void)didChangeValue:(HCSStarRatingView *)sender {
    NSInteger value = self.ratingView.value;
    self.rate = value * 2.0;
    switch (value) {
        case 1:
            self.rating.text = @"Tệ";
            break;
        case 2:
            self.rating.text = @"Cần cải thiện";
            break;
        case 3:
            self.rating.text = @"Bình thường";
            break;
        case 4:
            self.rating.text = @"Tốt";
            break;
        case 5:
            self.rating.text = @"Xuất sắc";
            break;
        default:
            self.rating.text = @"";
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(didChangeValue:)]) {
        [self.delegate didChangeValue:self.rate];
    }
}

@end
