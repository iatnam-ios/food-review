//
//  ListPhotoCollectionViewCell.h
//  FoodReview
//
//  Created by MTT on 08/07/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic) NSArray<NSString *> *photos;

+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
