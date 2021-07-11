//
//  RatingView.h
//  FoodReview
//
//  Created by MTT on 30/06/2021.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

NS_ASSUME_NONNULL_BEGIN

@class RatingView;

@protocol RatingViewDelegate<NSObject>

- (void)didChangeValue:(NSInteger)value;

@end

@interface RatingView : UIView

@property (nonatomic) id <RatingViewDelegate> delegate;
@property (nonatomic, strong) HCSStarRatingView *ratingView;
@property (nonatomic, strong) UILabel *ratingName;
@property (nonatomic, strong) UILabel *rating;
@property (nonatomic) NSInteger rate;

@end

NS_ASSUME_NONNULL_END
