//
//  ViewControllerRouter.m
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import "ViewControllerRouter.h"
#import "SearchPlacesViewController.h"
#import "SearchPlacesPresenter.h"
#import "PlaceListInteractorImplementation.h"
#import "RealtimeDatabaseGateway.h"

@implementation ViewControllerRouter

+ (instancetype)shared {
    static dispatch_once_t token;
    static ViewControllerRouter *sharedInstance;
    dispatch_once(&token, ^{
        sharedInstance = [[ViewControllerRouter alloc] init];
    });
    
    return sharedInstance;
}

-(UIViewController *)createSearchPlacesVC {
    RealtimeDatabaseGateway *gateway = [[RealtimeDatabaseGateway alloc] init];
    PlaceListInteractorImplementation *interactor = [[PlaceListInteractorImplementation alloc] initWithGateway:gateway];
    
    SearchPlacesPresenter *presenter = [[SearchPlacesPresenter alloc] init];
    presenter.placeListInteractor = interactor;
    
    SearchPlacesViewController *view = [[SearchPlacesViewController alloc] init];
    view.presenter = presenter;
    presenter.view = view;
    
    return view;
}

@end
