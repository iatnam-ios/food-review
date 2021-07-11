//
//  PostCollectionViewCell.h
//  FoodReview
//
//  Created by MTT on 23/05/2021.
//

#import "BaseCollectionCell.h"
#import "Review.h"

NS_ASSUME_NONNULL_BEGIN

@class PostCollectionViewCell;

@protocol PostCollectionCellDelegate <NSObject>

- (void)didPressLikeButton:(PostCollectionViewCell *)sender;

@end

@interface PostCollectionViewCell : BaseCollectionCell

+ (NSString *)identifier;
@property (nonatomic) UIImageView *avatarImage;

-(void)configCellWithReview:(Review *)review;

@end

NS_ASSUME_NONNULL_END
