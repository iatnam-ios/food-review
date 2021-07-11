//
//  TabBarWireFrame.m
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import "TabBarWireFrame.h"
#import "TabBarController.h"
#import "BusinessLogic.h"
#import "CreateReviewPresenterImp.h"
#import "AppDataAdapter.h"
#import "LandingViewController.h"
#import "LoginViewController.h"
#import "HomePresenterImp.h"

@interface TabBarWireFrame()

@property (nonatomic, strong) id<AppDataProvider> dataProvider;

@end

@implementation TabBarWireFrame

- (instancetype)initWithDataProvider:(id<AppDataProvider>)dataProvider {
    self = [super init];
    if (self) {
        self.dataProvider = dataProvider;
    }
    return self;
}

- (UIViewController *)rootViewController {
    TabBarController *tabBar = [TabBarController sharedInstance];
    AppDataAdapter *adapter = [[AppDataAdapter alloc] initWithDataSource:self.dataProvider];
    {
        id<HomeInteractor> interactor = [BusinessLogic makeHomeInteractor:adapter];
        tabBar.homeViewController.presenter = [[HomePresenterImp alloc] initWithWireframe:self interactor:interactor];
    }
    
    {
        id<CreateReviewInteractor> interactor = [BusinessLogic makeCreateReviewInteractor:adapter];
        tabBar.createViewController.presenter = [[CreateReviewPresenterImp alloc] initWithWireframe:self interactor:interactor];
    }
    
    
    
    return tabBar;
}

- (void)presentLandingViewWith:(id<LandingPresenter>)presenter fromView:(UIViewController *)viewController {
    LandingViewController *vc = [[LandingViewController alloc] init];
    vc.presenter = presenter;
    
    [viewController.navigationController pushViewController:vc animated:YES];
}

- (void)presentLoginViewWith:(id<LoginPresenter>)presenter fromView:(UIViewController *)viewController {
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.presenter = presenter;
    
    [viewController.navigationController pushViewController:vc animated:YES];
}

- (void)dismissViewController:(UIViewController *)viewController {
    [viewController.navigationController popToRootViewControllerAnimated:YES];
}

@end
