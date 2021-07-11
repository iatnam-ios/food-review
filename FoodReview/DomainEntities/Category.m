//
//  Category.m
//  FoodReview
//
//  Created by MTT on 09/06/2021.
//

#import "Category.h"

@implementation Category

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _categoryId = [dictionary[@"Id"] integerValue];
        _categoryName = dictionary[@"Name"];
        _urlRewriteName = dictionary[@"UrlRewriteName"];
        _resultCount = [dictionary[@"ResultCount"] integerValue];
        NSString *avatarImageName = dictionary[@"Avatar"];
        _avatar = [NSString stringWithFormat:@"https://images.foody.vn/caticon/s90x90/%@", avatarImageName];
    }
    return self;
}

@end
