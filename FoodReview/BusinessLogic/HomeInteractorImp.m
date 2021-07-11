//
//  HomeInteractorImp.m
//  FoodReview
//
//  Created by MTT on 29/06/2021.
//

#import "HomeInteractorImp.h"

@interface HomeInteractorImp()

@property (nonatomic, strong) id<AppDataStore> dataStore;

@end

@implementation HomeInteractorImp

@synthesize output;

- (instancetype)initWithDataStore:(id<AppDataStore>)dataStore {
    self = [super init];
    if(self)
    {
        self.dataStore = dataStore;
    }
    return self;
}

- (void)getEditorsChoice {
    if (self.dataStore) {
        [self.dataStore getEditorsChoiceWithBlock:^(NSArray<Category *> * _Nonnull places, NSError * _Nullable error) {
            [self.output didReceiveEditorsChoice:places];
        }];
    }
}

- (void)getTrending {
    if (self.dataStore) {
        [self.dataStore getTrendingWithBlock:^(NSArray<Category *> * _Nonnull places, NSError * _Nullable error) {
            [self.output didReceiveTrending:places];
        }];
    }
}

@end
