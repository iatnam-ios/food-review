//
//  Comment.h
//  FoodReview
//
//  Created by MTT on 30/06/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Comment : NSObject

@property (nonatomic, readonly) NSString *commentId;
@property (nonatomic, readonly) NSString *reviewId;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSDate *createdDate;
@property (nonatomic, readonly) NSString *userId;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *userAvatar;

- (instancetype)initWithUserId:(NSString *)userId reviewId:(NSString *)reviewId createdDate:(NSDate *)date andComment:(NSString *)content;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary andId:(NSString *)commentId;
- (NSDictionary *)getDictionary;

@end

NS_ASSUME_NONNULL_END
