//
//  User.h
//  FoodReview
//
//  Created by MTT on 05/06/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *userName;
@property (nonatomic, copy, readonly) NSString *displayName;
@property (nonatomic, copy, readonly) NSString *userDescription;
@property (nonatomic, copy, readonly) NSString *profileImageUrl;
@property (nonatomic, copy, readonly) NSDate   *birthday;
@property (nonatomic, readonly) NSInteger gender;

- (instancetype)initWithUserId:(NSString *)userId userName:(NSString *)userName displayName:(NSString *)displayName email:(NSString *)email;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)getDictionary;

@end

NS_ASSUME_NONNULL_END
