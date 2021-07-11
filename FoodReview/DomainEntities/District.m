//
//  District.m
//  FoodReview
//
//  Created by MTT on 09/06/2021.
//

#import "District.h"

@implementation District

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _districtId = [dictionary[@"id"] integerValue];
        _provinceId = [dictionary[@"province_id"] integerValue];
        _districtName = dictionary[@"name"];
    }
    return self;
}

@end
