//
//  PlaceCollectionViewCell.h
//  FoodReview
//
//  Created by MTT on 09/06/2021.
//

#import "BaseCollectionCell.h"
#import "Place.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaceCollectionViewCell : BaseCollectionCell

+ (NSString *)identifier;
- (void)configueWithPlace:(Place *)place andDistance:(NSString *)distance;

@end

NS_ASSUME_NONNULL_END
