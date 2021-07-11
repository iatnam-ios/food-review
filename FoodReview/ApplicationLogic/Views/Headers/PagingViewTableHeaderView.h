//
//  PagingViewTableHeaderView.h
//  FoodReview
//
//  Created by MTT on 22/05/2021.
//

#import <UIKit/UIKit.h>
#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface PagingViewTableHeaderView : UIView

@property (nonatomic, strong) NSArray<Category *> *editorsChoice;
@property (nonatomic, strong) NSArray<Category *> *trendings;

@end

NS_ASSUME_NONNULL_END
