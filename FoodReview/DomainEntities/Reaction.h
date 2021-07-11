//
//  Reaction.h
//  FoodReview
//
//  Created by MTT on 30/06/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Reaction : NSObject

@property (nonatomic) NSString *reactionId;
@property (nonatomic, copy, readonly) NSDate *createdDate;
@property (nonatomic) BOOL type;
@property (nonatomic, readonly) NSString *userId;
@property (nonatomic, readonly) NSString *reviewId;

- (instancetype)initWithUserId:(NSString *)userId reviewId:(NSString *)reviewId type:(BOOL)type andDate:(NSDate *)createdDate;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary andReactionId:(NSString *)reactionId;
-(NSDictionary *)getDictionary;

@end

NS_ASSUME_NONNULL_END
