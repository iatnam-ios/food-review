//
//  Review.m
//  FoodReview
//
//  Created by MTT on 10/06/2021.
//

#import "Review.h"

@implementation Review

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle createdDate:(NSDate *)date totalViews:(NSInteger)views userId:(NSString *)userId placeId:(NSInteger)placeId hashtags:(nonnull NSArray *)hashtags andImages:(nonnull NSArray *)images {
    self = [super init];
    if (self) {
        _title = title;
        _subtitle = subtitle;
        _createdDate = date;
        _totalViews = views;
        _userId = userId;
        _placeId = placeId;
        _hashtags = [NSMutableArray arrayWithArray:hashtags];
        _images = [NSMutableArray arrayWithArray:images];
        _likes = 0;
        _dislikes = 0;
        _comments = 0;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _title = dictionary[@"title"];
        _subtitle = dictionary[@"subtitle"];
        FIRTimestamp *date = dictionary[@"createdDate"];
        _createdDate = date.dateValue;
        _totalViews = [dictionary[@"totalViews"] integerValue];
        _likes = [dictionary[@"likes"] integerValue];
        _dislikes = [dictionary[@"dislikes"] integerValue];
        _comments = [dictionary[@"comments"] integerValue];
        _userId = dictionary[@"userId"];
        _reviewId = dictionary[@"reviewId"];
        _placeId = [dictionary[@"placeId"] integerValue];
        _images = dictionary[@"photos"];
        _userName = dictionary[@"userName"];
        _userAvatar = dictionary[@"userAvatar"];
        _hashtags = dictionary[@"hashtags"];
        _rate = [[Rating alloc] initWithDictionary:dictionary[@"rate"]];
    }
    return self;
}

- (NSDictionary *)getDictionary {
    FIRTimestamp *timeStamp = [FIRTimestamp timestampWithDate:self.createdDate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"title"] = self.title;
    dict[@"subtitle"] = self.subtitle;
    dict[@"totalViews"] = [NSNumber numberWithInteger:self.totalViews];
    dict[@"likes"] = [NSNumber numberWithInteger:self.likes];
    dict[@"dislikes"] = [NSNumber numberWithInteger:self.dislikes];
    dict[@"comments"] = [NSNumber numberWithInteger:self.comments];
    dict[@"userId"] = self.userId;
    dict[@"placeId"] = [NSNumber numberWithInteger:self.placeId];
    dict[@"createdDate"] = timeStamp;
    dict[@"rate"] = [self.rate getDictionary];
    dict[@"userName"] = self.userName;
    dict[@"userAvatar"] = self.userAvatar;
    dict[@"hashtags"] = self.hashtags;
    dict[@"photos"] = self.images;
    return dict;
}

@end
