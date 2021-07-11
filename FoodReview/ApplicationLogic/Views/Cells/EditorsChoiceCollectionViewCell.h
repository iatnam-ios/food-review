//
//  EditorsChoiceCollectionViewCell.h
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#import <UIKit/UIKit.h>
#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditorsChoiceCollectionViewCell : UICollectionViewCell

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSArray<Category *> *editorsChoice;

+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
