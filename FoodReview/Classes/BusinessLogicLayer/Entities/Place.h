//
//  Place.h
//  FoodReview
//
//  Created by MTT on 08/06/2021.
//

#import <Foundation/Foundation.h>
#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface Place : NSObject

@property (nonatomic, readonly) NSInteger placeId;
@property (nonatomic, copy, readonly) NSString *placeName;
@property (nonatomic, copy, readonly) NSString *address;
@property (nonatomic, copy, readonly) NSString *district;
@property (nonatomic, readonly) NSInteger districtId;
@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, readonly) NSInteger locationId;
@property (nonatomic, readonly) NSInteger mainCategoryId;
@property (nonatomic, copy, readonly) NSArray<NSDictionary *> *cuisines;
@property (nonatomic, copy, readonly) NSArray<Category *> *categories;
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;
@property (nonatomic, readonly) NSInteger totalReviews;
@property (nonatomic, readonly) double avgRatingOriginal;
@property (nonatomic, copy, readonly) NSString *picturePath;
@property (nonatomic, copy, readonly) NSString *picturePathLarge;
@property (nonatomic, copy, readonly) NSString *mobilePicturePath;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
