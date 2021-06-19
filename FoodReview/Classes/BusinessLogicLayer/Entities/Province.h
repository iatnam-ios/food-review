//
//  Province.h
//  FoodReview
//
//  Created by MTT on 09/06/2021.
//

#import <Foundation/Foundation.h>
#import "District.h"

NS_ASSUME_NONNULL_BEGIN

@interface Province : NSObject

@property (nonatomic, readonly) NSInteger provinceId;
@property (nonatomic, readonly) NSInteger countryId;
@property (nonatomic, copy, readonly) NSString *provinceName;
@property (nonatomic, copy, readonly) NSString *urlName;
@property (nonatomic, copy, readonly) NSArray<District *> *districts;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
