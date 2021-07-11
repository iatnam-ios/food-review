//
//  UserCollectionViewCell.h
//  FoodReview
//
//  Created by MTT on 11/07/2021.
//

#import "BaseCollectionCell.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCollectionViewCell : BaseCollectionCell

+ (NSString *)identifier;
- (void)configueWithUser:(User *)user;

@end

NS_ASSUME_NONNULL_END
