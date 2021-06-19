//
//  PlaceCollectionViewCell.m
//  FoodReview
//
//  Created by MTT on 09/06/2021.
//

#import "PlaceCollectionViewCell.h"

@interface PlaceCollectionViewCell()

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *reviewLabel;
@property (nonatomic, strong) UILabel *distanceLabel;

@end

@implementation PlaceCollectionViewCell

#pragma mark - UpdateUIAppearances

- (void)updateUIAppearances {
    self.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.titleLabel.numberOfLines = 1;
    
    self.artwork.layer.cornerRadius = 6.0;
    self.artwork.clipsToBounds = YES;
}

#pragma mark - Identifier

+ (NSString *)identifier {
    return @"reusePlaceCollectionViewCell";
}

#pragma mark - Set Up Views

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = UIColor.steelColor;
        _addressLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    }
    return _addressLabel;
}

- (UILabel *)reviewLabel {
    if (!_reviewLabel) {
        _reviewLabel = [[UILabel alloc] init];
        _reviewLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    }
    return _reviewLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.textColor = UIColor.steelColor;
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        _distanceLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    }
    return _distanceLabel;
}

- (void)setupViews {
    [self.contentView addSubview:self.artwork];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.reviewLabel];
    [self.contentView addSubview:self.distanceLabel];
    
    [self.artwork mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading);
        make.top.equalTo(self.contentView.mas_top);
        make.height.equalTo(self.contentView.mas_height);
        make.width.equalTo(self.artwork.mas_height);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.artwork.mas_trailing).offset(14.0);
        make.trailing.equalTo(self.contentView.mas_trailing);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(24.0);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.artwork.mas_trailing).offset(14.0);
        make.trailing.equalTo(self.contentView.mas_trailing);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4.0);
        make.height.mas_equalTo(24.0);
    }];
    
    [self.reviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.artwork.mas_trailing).offset(14.0);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-50.0);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(4.0);
        make.height.mas_equalTo(24.0);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_trailing);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(4.0);
        make.height.mas_equalTo(24.0);
        make.width.mas_equalTo(48.0);
    }];
}

#pragma mark - Configuration

- (void)configueWithPlace:(Place *)place andDistance:(NSString *)distance {
    [self.artwork sd_setImageWithURL:[NSURL URLWithString:place.picturePath] placeholderImage:[Common imageFromColor:UIColor.purpleColor]];
    self.titleLabel.text = place.placeName;
    self.addressLabel.text = place.address;
    self.distanceLabel.text = distance;
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage systemImageNamed:@"star.fill"];

    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *reviewString = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    NSMutableAttributedString *addString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f/5 Điểm (%ld Đánh giá)", (place.avgRatingOriginal / 2.0), (long)place.totalReviews]];
    [addString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, 3)];
    [reviewString appendAttributedString:addString];

    self.reviewLabel.attributedText = reviewString;
}

@end
