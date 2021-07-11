//
//  LandingInteractorImp.m
//  FoodReview
//
//  Created by MTT on 20/06/2021.
//

#import "LandingInteractorImp.h"
#import "LoginInteractorImp.h"

@interface LandingInteractorImp()

@property (nonatomic, strong) id<AppDataStore> dataStore;

@end

@implementation LandingInteractorImp

@synthesize output;

- (instancetype)initWithDataStore:(id<AppDataStore>)dataStore {
    self = [super init];
    if(self)
    {
        self.dataStore = dataStore;
    }
    return self;
}

- (id<LoginInteractor>)makeLoginInteractor {
    LoginInteractorImp *interactor = [[LoginInteractorImp alloc] initWithDataStore:self.dataStore];
    return interactor;
}

@end
