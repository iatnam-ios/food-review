//
//  Category.h
//  FoodReview
//
//  Created by MTT on 09/06/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Category : NSObject

@property (nonatomic, readonly) NSInteger categoryId;
@property (nonatomic, copy, readonly) NSString *categoryName;
@property (nonatomic, copy, readonly) NSString *urlRewriteName;
@property (nonatomic, copy, readonly) NSString *avatar;
@property (nonatomic, readonly) NSInteger resultCount;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
