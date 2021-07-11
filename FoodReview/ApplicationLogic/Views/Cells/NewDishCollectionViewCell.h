//
//  NewDishCollectionViewCell.h
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#import "BaseCollectionCell.h"
#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewDishCollectionViewCell : BaseCollectionCell

+ (NSString *)identifier;
-(void)configCellWithPlace:(Category *)category;

@end

NS_ASSUME_NONNULL_END
