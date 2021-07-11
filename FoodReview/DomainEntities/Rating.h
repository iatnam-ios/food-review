//
//  Rating.h
//  FoodReview
//
//  Created by MTT on 30/06/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Rating : NSObject

@property (nonatomic) float overall;
@property (nonatomic) float price;
@property (nonatomic) float smell;
@property (nonatomic) float serve;
@property (nonatomic) float hygiene;
@property (nonatomic) float space;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)getDictionary;

@end

NS_ASSUME_NONNULL_END
