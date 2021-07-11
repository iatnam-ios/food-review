//
//  Review.h
//  FoodReview
//
//  Created by MTT on 10/06/2021.
//

#import <Foundation/Foundation.h>
#import "Rating.h"
#import "Reaction.h"
#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface Review : NSObject

@property (nonatomic) NSString *reviewId;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;
@property (nonatomic, copy, readonly) NSDate *createdDate;
@property (nonatomic, copy, readonly) NSMutableArray<NSString *> *images;
@property (nonatomic, copy, readonly) NSMutableArray<NSString *> *hashtags;
@property (nonatomic) NSInteger totalViews;
@property (nonatomic) NSInteger likes;
@property (nonatomic) NSInteger dislikes;
@property (nonatomic) NSInteger comments;
@property (nonatomic, readonly) NSString *userId;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *userAvatar;
@property (nonatomic, readonly) NSInteger placeId;
@property (nonatomic) Rating *rate;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle createdDate:(NSDate *)date totalViews:(NSInteger)views userId:(NSString *)userId placeId:(NSInteger)placeId hashtags:(NSArray *)hashtags andImages:(NSArray *)images;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)getDictionary;

@end

NS_ASSUME_NONNULL_END
