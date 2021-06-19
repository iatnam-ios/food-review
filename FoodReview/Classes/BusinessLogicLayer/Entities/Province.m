//
//  Province.m
//  FoodReview
//
//  Created by MTT on 09/06/2021.
//

#import "Province.h"

@implementation Province

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _provinceId = [dictionary[@"id"] integerValue];
        _provinceName = dictionary[@"name"];
        _urlName = dictionary[@"name_url"];
        _countryId = [dictionary[@"country_id"] integerValue];
        
        NSMutableArray *districts = [NSMutableArray new];
        NSArray *array = dictionary[@"district"];
        for (NSDictionary *dict in array) {
            District *district = [[District alloc] initWithDictionary:dict];
            [districts addObject:district];
        }
        _districts = [NSArray arrayWithArray:districts];
    }
    return self;
}

@end
