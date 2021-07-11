//
//  LoginInteractorImp.m
//  FoodReview
//
//  Created by MTT on 20/06/2021.
//

#import "LoginInteractorImp.h"

@interface LoginInteractorImp()

@property (nonatomic, strong) id<AppDataStore> dataStore;

@end

@implementation LoginInteractorImp

@synthesize output;

- (instancetype)initWithDataStore:(id<AppDataStore>)dataStore {
    self = [super init];
    if(self)
    {
        self.dataStore = dataStore;
    }
    return self;
}

- (void)loginWithEmail:(nonnull NSString *)email andPassword:(nonnull NSString *)password {
    if (self.dataStore) {
        [self.dataStore loginWithEmail:email password:password andWithBlock:^(User * _Nullable user, NSString * _Nullable error) {
            if (error) {
                [self.output didLoginError:error];
            } else if (user) {
                [self.output didLoginWith:user];
            }
        }];
    }
}

@end
