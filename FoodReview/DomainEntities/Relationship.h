//
//  Relationship.h
//  FoodReview
//
//  Created by MTT on 30/06/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Relationship : NSObject

@property (nonatomic, readonly) NSString *relationshipId;
@property (nonatomic, copy, readonly) NSDate *createdDate;
@property (nonatomic, readonly) NSString *followerId;
@property (nonatomic, readonly) NSString *followedId;

- (instancetype)initWithFollowerId:(NSString *)followerId followedId:(NSString *)followedId createdDate:(NSDate *)date;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)getDictionary;

@end

NS_ASSUME_NONNULL_END
