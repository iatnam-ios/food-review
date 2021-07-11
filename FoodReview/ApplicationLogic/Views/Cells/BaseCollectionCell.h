//
//  BaseCollectionCell.h
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseCollectionCell : UICollectionViewCell

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *backingView;
@property (nonatomic) UIImageView *artwork;

@end

NS_ASSUME_NONNULL_END
