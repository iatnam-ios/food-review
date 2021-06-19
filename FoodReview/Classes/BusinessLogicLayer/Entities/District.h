//
//  District.h
//  FoodReview
//
//  Created by MTT on 09/06/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface District : NSObject

@property (nonatomic, readonly) NSInteger districtId;
@property (nonatomic, readonly) NSInteger provinceId;
@property (nonatomic, copy, readonly) NSString *districtName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
