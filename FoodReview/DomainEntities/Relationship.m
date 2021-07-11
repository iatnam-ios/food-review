//
//  Relationship.m
//  FoodReview
//
//  Created by MTT on 30/06/2021.
//

#import "Relationship.h"

@implementation Relationship

- (instancetype)initWithFollowerId:(NSString *)followerId followedId:(NSString *)followedId createdDate:(nonnull NSDate *)date {
    self = [super init];
    if (self) {
        _relationshipId = [NSString stringWithFormat:@"%@_%@", followerId, followedId];
        _createdDate = date;
        _followerId = followerId;
        _followedId = followedId;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _relationshipId = dictionary[@"relationshipId"];
        FIRTimestamp *date = dictionary[@"createdDate"];
        _createdDate = date.dateValue;
        _followerId = dictionary[@"followerId"];
        _followedId = dictionary[@"followedId"];
    }
    return self;
}

- (NSDictionary *)getDictionary {
    FIRTimestamp *timeStamp = [FIRTimestamp timestampWithDate:self.createdDate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"relationshipId"] = self.relationshipId;
    dict[@"createdDate"] = timeStamp;
    dict[@"followerId"] = self.followerId;
    dict[@"followedId"] = self.followedId;
    return dict;
}

@end
