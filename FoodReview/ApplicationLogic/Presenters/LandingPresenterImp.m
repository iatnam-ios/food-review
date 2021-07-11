//
//  LandingPresenterImp.m
//  FoodReview
//
//  Created by MTT on 20/06/2021.
//

#import "LandingPresenterImp.h"
#import "BusinessLogic.h"
#import "LoginPresenterImp.h"
#import "LoginInteractorImp.h"

@interface LandingPresenterImp()

@property (nonatomic, strong) id<BrowserWireframe> wireframe;
@property (nonatomic, strong) id<LandingInteractor> interactor;

@end

@implementation LandingPresenterImp

@synthesize output;

- (instancetype)initWithWireframe:(id<BrowserWireframe>)wireframe interactor:(id<LandingInteractor>)interactor {
    self = [super init];
    if (self) {
        self.wireframe = wireframe;
        self.interactor = interactor;
        interactor.output = self;
    }
    return self;
}

- (void)didPressLoginButton {
    LoginInteractorImp *subInteractor = [self.interactor makeLoginInteractor];
    LoginPresenterImp *subPresenter = [[LoginPresenterImp alloc] initWithWireframe:self.wireframe interactor:subInteractor];
    [self.wireframe presentLoginViewWith:subPresenter fromView:self.output];
}

- (void)didPressSignUpButton {
    
}

@end
