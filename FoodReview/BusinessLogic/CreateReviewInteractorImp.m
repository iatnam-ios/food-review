//
//  CreateReviewInteractorImp.m
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import "CreateReviewInteractorImp.h"
#import "LandingInteractorImp.h"

@interface CreateReviewInteractorImp()

@property (nonatomic, strong) id<AppDataStore> dataStore;

@end

@implementation CreateReviewInteractorImp

@synthesize output;

- (instancetype)initWithDataStore:(id<AppDataStore>)dataStore {
    self = [super init];
    if(self)
    {
        self.dataStore = dataStore;
    }
    return self;
}

- (void)getCurrentUser {
    if (self.dataStore) {
        [self.dataStore getCurrentUserWithBlock:^(User *user) {
            [self.output didReceiveCurrentUser:user];
        }];
    }
}

- (id<LandingInteractor>)makeLandingInteractor {
    LandingInteractorImp *interactor = [[LandingInteractorImp alloc] initWithDataStore:self.dataStore];
    return interactor;
}

@end
