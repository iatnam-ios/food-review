//
//  HomePresenterImp.m
//  FoodReview
//
//  Created by MTT on 29/06/2021.
//

#import "HomePresenterImp.h"

@interface HomePresenterImp()

@property (nonatomic, strong) id<BrowserWireframe> wireframe;
@property (nonatomic, strong) id<HomeInteractor> interactor;

@end

@implementation HomePresenterImp

@synthesize output;

- (instancetype)initWithWireframe:(id<BrowserWireframe>)wireframe interactor:(id<HomeInteractor>)interactor {
    self = [super init];
    if (self) {
        self.wireframe = wireframe;
        self.interactor = interactor;
        interactor.output = self;
    }
    return self;
}

- (void)viewDidLoad {
    [self getEditorsChoice];
    [self getTrending];
}

- (void)getEditorsChoice {
    [self.interactor getEditorsChoice];
}

- (void)getTrending {
    [self.interactor getTrending];
}

- (void)didReceiveEditorsChoice:(NSArray<Category *> *)items {
    [self.output presenterDidReceiveEditorsChoice:items];
}

- (void)didReceiveTrending:(NSArray<Category *> *)items {
    [self.output presenterDidReceiveTrending:items];
}

@end
