//
//  CreateReviewPresenterImp.m
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import "CreateReviewPresenterImp.h"
#import "LandingInteractorImp.h"
#import "LandingPresenterImp.h"

@interface CreateReviewPresenterImp()

@property (nonatomic, strong) id<BrowserWireframe> wireframe;
@property (nonatomic, strong) id<CreateReviewInteractor> interactor;

@end

@implementation CreateReviewPresenterImp

@synthesize output;

- (instancetype)initWithWireframe:(id<BrowserWireframe>)wireframe interactor:(id<CreateReviewInteractor>)interactor {
    self = [super init];
    if (self) {
        self.wireframe = wireframe;
        self.interactor = interactor;
        interactor.output = self;
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"view load");
    [self.interactor getCurrentUser];
}

- (void)didReceiveCurrentUser:(nullable User *)user {
    if (user) {
        NSLog(@"co user");
    } else {
        NSLog(@" ko user");
        [self showLandingView];
    }
}

-(void)showLandingView {
    LandingInteractorImp *subInteractor = [self.interactor makeLandingInteractor];
    LandingPresenterImp *subPresenter = [[LandingPresenterImp alloc] initWithWireframe:self.wireframe interactor:subInteractor];
    [self.wireframe presentLandingViewWith:subPresenter fromView:self.output];
}

@end
