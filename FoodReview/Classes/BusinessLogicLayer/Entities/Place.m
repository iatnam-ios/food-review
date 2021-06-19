//
//  Place.m
//  FoodReview
//
//  Created by MTT on 08/06/2021.
//

#import "Place.h"

@implementation Place

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _placeId = [dictionary[@"Id"] integerValue];
        _placeName = dictionary[@"Name"];
        _address = dictionary[@"Address"];
        _categories = dictionary[@"District"];
        _city = dictionary[@"City"];
        _districtId = [dictionary[@"DistrictId"] integerValue];
        _locationId = [dictionary[@"LocationId"] integerValue];
        _latitude = [dictionary[@"Latitude"] doubleValue];
        _longitude = [dictionary[@"Longitude"] doubleValue];
        _mainCategoryId = [dictionary[@"MainCategoryId"] integerValue];
        _totalReviews = [dictionary[@"TotalReview"] integerValue];
        _avgRatingOriginal = [dictionary[@"AvgRatingOriginal"] integerValue];
        _picturePath = dictionary[@"PicturePath"];
        _picturePathLarge = dictionary[@"PicturePathLarge"];
        _mobilePicturePath = dictionary[@"MobilePicturePath"];
        _cuisines = dictionary[@"Cuisines"];
        
        NSMutableArray *categories = [NSMutableArray new];
        NSArray *array = dictionary[@"Categories"];
        for (NSDictionary *dict in array) {
            Category *category = [[Category alloc] initWithDictionary:dict];
            [categories addObject:category];
        }
        _categories = [NSArray arrayWithArray:categories];
    }
    return self;
}

@end
