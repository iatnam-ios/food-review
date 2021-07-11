//
//  Reaction.m
//  FoodReview
//
//  Created by MTT on 30/06/2021.
//

#import "Reaction.h"

@implementation Reaction

- (instancetype)initWithUserId:(NSString *)userId reviewId:(NSString *)reviewId type:(BOOL)type andDate:(NSDate *)createdDate {
    self = [super init];
    if (self) {
        _createdDate = createdDate;
        _type = type;
        _userId = userId;
        _reviewId = reviewId;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andReactionId:(nonnull NSString *)reactionId {
    self = [super init];
    if (self) {
        _reactionId = reactionId;
        FIRTimestamp *date = dictionary[@"createdDate"];
        _createdDate = date.dateValue;
        _type = [dictionary[@"type"] boolValue];
        _userId = dictionary[@"userId"];
        _reviewId = dictionary[@"reviewId"];
    }
    return self;
}

- (NSDictionary *)getDictionary {
    FIRTimestamp *timeStamp = [FIRTimestamp timestampWithDate:self.createdDate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"userId"] = self.userId;
    dict[@"reviewId"] = self.reviewId;
    dict[@"createdDate"] = timeStamp;
    dict[@"type"] = [NSNumber numberWithBool:self.type];
    return dict;
}

@end
