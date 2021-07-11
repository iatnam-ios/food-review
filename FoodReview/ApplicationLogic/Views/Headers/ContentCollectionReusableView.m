//
//  ContentCollectionReusableView.m
//  FoodReview
//
//  Created by MTT on 09/07/2021.
//

#import "ContentCollectionReusableView.h"

@interface ContentCollectionReusableView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *hashtagLabel;
@property (nonatomic, strong) UILabel *reviewLabel;
@property (nonatomic, strong) UILabel *viewsLabel;

@end

@implementation ContentCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
        [self setupViews];
    }
    
    return self;
}

+ (NSString *)identifier {
    return @"reuseBaseCollectionReusableView";
}

#pragma mark - Initialize

- (void)initialize {
    self.backgroundColor = UIColor.whiteColor;
}

#pragma mark - SetupViews

- (UILabel *)reviewLabel {
    if (!_reviewLabel) {
        _reviewLabel = [[UILabel alloc] init];
        _reviewLabel.font = UIFont.titleSmall;
        _reviewLabel.textColor = UIColor.steelColor;
    }
    return _reviewLabel;
}

- (UILabel *)viewsLabel {
    if (!_viewsLabel) {
        _viewsLabel = [[UILabel alloc] init];
        _viewsLabel.font = UIFont.titleSmall;
        _viewsLabel.textColor = UIColor.steelColor;
        _viewsLabel.textAlignment = NSTextAlignmentRight;
    }
    return _viewsLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = UIFont.titleBold;
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = UIFont.subtitleLight;
        _contentLabel.textColor = UIColor.steelColor;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)hashtagLabel {
    if (_hashtagLabel == nil) {
        _hashtagLabel = [[UILabel alloc] init];
        _hashtagLabel.font = UIFont.titleRegular;
        _hashtagLabel.textColor = UIColor.redPinkColor;
        _hashtagLabel.numberOfLines = 0;
    }
    return _hashtagLabel;
}

- (void)setupViews {
    [self addSubview:self.reviewLabel];
    [self addSubview:self.viewsLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.hashtagLabel];
    
    [self.reviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10.0);
        make.leading.mas_equalTo(self.mas_leading).offset(14.0);
        make.height.mas_equalTo(20.0);
    }];
    
    [self.viewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10.0);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-14.0);
        make.height.mas_equalTo(20.0);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.reviewLabel.mas_bottom).offset(14.0);
        make.leading.mas_equalTo(self.mas_leading).offset(14.0);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-14.0);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10.0);
        make.leading.mas_equalTo(self.mas_leading).offset(14.0);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-14.0);
    }];

    [self.hashtagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(14.0);
        make.leading.mas_equalTo(self.mas_leading).offset(14.0);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-14.0);
    }];
}

-(void)configViewWithTitle:(NSString *)title content:(NSString *)content hashtag:(NSString *)hashtag rating:(float)rate andTotalViews:(NSInteger)value {
    [self setReviewLabelWithRating:rate];
    [self setViewsLabelWithValue:value];
    
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    self.hashtagLabel.text = hashtag;
}

-(void)setReviewLabelWithRating:(float)rate {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage systemImageNamed:@"star.fill"];

    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *reviewString = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    NSMutableAttributedString *addString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f/5 Điểm", (rate / 2.0)]];
    [addString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, 3)];
    [reviewString appendAttributedString:addString];

    self.reviewLabel.attributedText = reviewString;
}

-(void)setViewsLabelWithValue:(NSInteger)value {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage systemImageNamed:@"eye"];

    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *viewsString = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    NSMutableAttributedString *addString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)value]];

    [viewsString appendAttributedString:addString];

    self.viewsLabel.attributedText = viewsString;
}

@end
