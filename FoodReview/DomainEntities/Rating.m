//
//  Rating.m
//  FoodReview
//
//  Created by MTT on 30/06/2021.
//

#import "Rating.h"

@implementation Rating

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _overall = [dictionary[@"overall"] floatValue];
        _price = [dictionary[@"price"] floatValue];
        _smell = [dictionary[@"smell"] floatValue];
        _serve = [dictionary[@"serve"] floatValue];
        _space = [dictionary[@"space"] floatValue];
        _hygiene = [dictionary[@"hygiene"] floatValue];
    }
    return self;
}

-(NSDictionary *)getDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"overall"] = [NSNumber numberWithFloat:self.overall];
    dict[@"smell"] = [NSNumber numberWithFloat:self.smell];
    dict[@"space"] = [NSNumber numberWithFloat:self.space];
    dict[@"hygiene"] = [NSNumber numberWithFloat:self.hygiene];
    dict[@"price"] = [NSNumber numberWithFloat:self.price];
    dict[@"serve"] = [NSNumber numberWithFloat:self.serve];
    return dict;
}

@end
