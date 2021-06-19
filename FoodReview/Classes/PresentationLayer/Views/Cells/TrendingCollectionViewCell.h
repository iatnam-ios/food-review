//
//  TrendingCollectionViewCell.h
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrendingCollectionViewCell : UICollectionViewCell

@property (nonatomic) UICollectionView *collectionView;

+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
