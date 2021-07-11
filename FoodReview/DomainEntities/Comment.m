//
//  Comment.m
//  FoodReview
//
//  Created by MTT on 30/06/2021.
//

#import "Comment.h"

@implementation Comment

- (instancetype)initWithUserId:(NSString *)userId reviewId:(NSString *)reviewId createdDate:(NSDate *)date andComment:(NSString *)content {
    self = [super init];
    if (self) {
        _reviewId = reviewId;
        _createdDate = date;
        _userId = userId;
        _content = content;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary andId:(nonnull NSString *)commentId {
    self = [super init];
    if (self) {
        _commentId = commentId;
        FIRTimestamp *date = dictionary[@"createdDate"];
        _createdDate = date.dateValue;
        _commentId = dictionary[@"commentId"];
        _reviewId = dictionary[@"reviewId"];
        _content = dictionary[@"content"];
        _userId = dictionary[@"userId"];
        _userName = dictionary[@"userName"];
        _userAvatar = dictionary[@"userAvatar"];
    }
    return self;
}

- (NSDictionary *)getDictionary {
    FIRTimestamp *timeStamp = [FIRTimestamp timestampWithDate:self.createdDate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"reviewId"] = self.reviewId;
    dict[@"createdDate"] = timeStamp;
    dict[@"userId"] = self.userId;
    dict[@"content"] = self.content;
    return dict;
}

@end
