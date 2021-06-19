//
//  Review.h
//  FoodReview
//
//  Created by MTT on 10/06/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Review : NSObject

@property (nonatomic, readonly) NSInteger reviewId;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;
@property (nonatomic, copy, readonly) NSDate *createdDate;
@property (nonatomic, readonly) NSInteger totalViews;


@end

NS_ASSUME_NONNULL_END
