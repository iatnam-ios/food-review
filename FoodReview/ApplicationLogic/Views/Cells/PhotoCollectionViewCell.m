//
//  PhotoCollectionViewCell.m
//  FoodReview
//
//  Created by MTT on 29/06/2021.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

#pragma mark - UpdateUIAppearances

- (void)updateUIAppearances {
    self.layer.cornerRadius = 10.0;
    self.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textColor = UIColor.systemBlueColor;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.tintColor = UIColor.systemBlueColor;
}

#pragma mark - Identifier

+ (NSString *)identifier {
    return @"reusePhotoCollectionViewCell";
}

#pragma mark - Set Up Views

- (void)setupViews {
    [self.contentView addSubview:self.artwork];
    [self.contentView addSubview:self.titleLabel];
    
    [self.artwork mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

#pragma mark - Configuration

- (void)configCellWithImageUrl:(NSURL *)imageUrl {
    self.layer.masksToBounds = NO;
    self.titleLabel.hidden = YES;
    self.artwork.hidden = NO;
    [self.artwork sd_setImageWithURL:imageUrl placeholderImage:[Common imageFromColor:UIColor.darkGrayColor]];
}

-(void)configCellWithImage:(UIImage *)image {
    self.titleLabel.hidden = YES;
    self.artwork.hidden = NO;
    self.artwork.image = image;
}

- (void)configCellAddImage {
    self.titleLabel.hidden = NO;
    self.artwork.hidden = YES;
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [[UIImage systemImageNamed:@"photo.on.rectangle"] imageWithTintColor:UIColor.systemBlueColor renderingMode:UIImageRenderingModeAlwaysTemplate];

    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    NSMutableAttributedString *addString = [[NSMutableAttributedString alloc] initWithString:@"Thêm ảnh"];
    [title appendAttributedString:addString];

    self.titleLabel.attributedText = title;
}

@end
