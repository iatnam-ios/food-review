//
//  AppDataAdapter.m
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import "AppDataAdapter.h"

@interface AppDataAdapter()

@property (nonatomic, strong) id<AppDataProvider> dataSource;

@end

@implementation AppDataAdapter

- (instancetype)initWithDataSource:(id<AppDataProvider>)dataSource {
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
    }
    return self;
}

- (void)getCurrentUserWithBlock:(nonnull UserResponseBlock)block {
    [self.dataSource getCurrentUserWithBlock:block];
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password andWithBlock:(LoginResponseBlock)block {
    [self.dataSource loginWithEmail:email password:password andWithBlock:block];
}

- (void)getPlacesFromDistrictId:(NSInteger)districtId withBlock:(nonnull PlacesResponseBlock)block {
    [self.dataSource getPlacesFromDistrictId:districtId withBlock:block];
}

- (void)getPlacesMatchSearchString:(nonnull NSString *)searchText withBlock:(nonnull PlacesResponseBlock)block {
    [self.dataSource getPlacesMatchSearchString:searchText withBlock:block];
}

- (void)getEditorsChoiceWithBlock:(CategoriesResponseBlock)block {
    [self.dataSource getEditorsChoiceWithBlock:block];
}

- (void)getTrendingWithBlock:(CategoriesResponseBlock)block {
    [self.dataSource getTrendingWithBlock:block];
}

@end
