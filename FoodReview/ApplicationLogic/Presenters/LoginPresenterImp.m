//
//  LoginPresenterImp.m
//  FoodReview
//
//  Created by MTT on 20/06/2021.
//

#import "LoginPresenterImp.h"
#import "BusinessLogic.h"

@interface LoginPresenterImp()

@property (nonatomic, strong) id<BrowserWireframe> wireframe;
@property (nonatomic, strong) id<LoginInteractor> interactor;

@end

@implementation LoginPresenterImp

@synthesize output;

- (instancetype)initWithWireframe:(id<BrowserWireframe>)wireframe interactor:(id<LoginInteractor>)interactor {
    self = [super init];
    if (self) {
        self.wireframe = wireframe;
        self.interactor = interactor;
        interactor.output = self;
    }
    return self;
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password {
    [self.interactor loginWithEmail:email andPassword:password];
}

- (void)didLoginError:(nonnull NSString *)error {
    [self.wireframe dismissViewController:self.output];
}

- (void)didLoginWith:(nonnull User *)user {
    [self.wireframe dismissViewController:self.output];
}

@end
