//
//  NewDishCollectionViewCell.m
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#import "NewDishCollectionViewCell.h"

@implementation NewDishCollectionViewCell

#pragma mark - UpdateUIAppearances

- (void)updateUIAppearances {
    self.layer.cornerRadius = 10.0;
    self.backgroundColor = UIColor.systemGroupedBackgroundColor;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textColor = UIColor.lightTextColor;
}

#pragma mark - Identifier

+ (NSString *)identifier {
    return @"reuseNewDishCollectionViewCell";
}

#pragma mark - Set Up Views

- (void)setupViews {
    [self.contentView addSubview:self.artwork];
    [self.artwork addSubview:self.titleLabel];
    
    [self.artwork mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.artwork.mas_leading).offset(14.0);
        make.trailing.equalTo(self.artwork.mas_trailing).offset(-14.0);
        make.bottom.equalTo(self.artwork.mas_bottom).offset(-10.0);
        make.height.mas_equalTo(40.0);
    }];
}

#pragma mark - Configuration

-(void)configCellWithPlace:(Category *)category {
    self.titleLabel.text = category.categoryName;
    [self.artwork sd_setImageWithURL:[NSURL URLWithString:category.avatar] placeholderImage:[Common imageFromColor:UIColor.darkGrayColor]];
}

@end
