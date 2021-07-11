//
//  ApplicationLogic.h
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DomainEntities.h"

@protocol AppDataProvider;
@protocol AppPresenter;
@protocol CreateReviewPresenter;
@protocol CreateReviewPresenterOutput;
@protocol LandingPresenter;
@protocol LandingPresenterOutput;
@protocol LoginPresenter;
@protocol LoginPresenterOutput;
@protocol HomePresenter;
@protocol HomePresenterOutput;

@protocol BrowserWireframe;

#pragma mark - AppDataProvider

@protocol AppDataProvider

-(void)getCurrentUserWithBlock:(UserResponseBlock)block;

-(void)loginWithEmail:(NSString *)email password:(NSString *)password andWithBlock:(LoginResponseBlock)block;

-(void)getPlacesMatchSearchString:(NSString *)searchText withBlock:(PlacesResponseBlock)block;

-(void)getPlacesFromDistrictId:(NSInteger)districtId withBlock:(PlacesResponseBlock)block;

-(void)getEditorsChoiceWithBlock:(CategoriesResponseBlock)block;
-(void)getTrendingWithBlock:(CategoriesResponseBlock)block;

@end

#pragma mark - AppPresenter

@protocol AppPresenter <NSObject>

@optional
-(void)viewDidLoad;
-(void)viewWillAppear;
-(void)viewWillDisappear;

@end

#pragma mark - CreateReviewPresenter

@protocol CreateReviewPresenter <AppPresenter>

@property (nonatomic, weak) id<CreateReviewPresenterOutput> output;

@end

#pragma mark - CreateReviewPresenterOutput

@protocol CreateReviewPresenterOutput <NSObject>


@end

#pragma mark - LandingPresenter

@protocol LandingPresenter <AppPresenter>

@property (nonatomic, weak) id<LandingPresenterOutput> output;

-(void)didPressLoginButton;
-(void)didPressSignUpButton;

@end

#pragma mark - LandingPresenterOutput

@protocol LandingPresenterOutput <NSObject>


@end

#pragma mark - LoginPresenter

@protocol LoginPresenter <AppPresenter>

@property (nonatomic, weak) id<LoginPresenterOutput> output;

-(void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;

@end

#pragma mark - LoginPresenterOutput

@protocol LoginPresenterOutput <NSObject>


@end

#pragma mark - HomePresenter

@protocol HomePresenter <AppPresenter>

@property (nonatomic, weak) id<HomePresenterOutput> output;

@end

#pragma mark - HomePresenterOutput

@protocol HomePresenterOutput <NSObject>

-(void)presenterDidReceiveEditorsChoice:(NSArray<Category *> *)items;
-(void)presenterDidReceiveTrending:(NSArray<Category *> *)items;

@end

#pragma mark - BrowserWireframe

@protocol BrowserWireframe <NSObject>

-(void)presentLandingViewWith:(id<LandingPresenter>)presenter fromView:(UIViewController *)viewController;
-(void)presentLoginViewWith:(id<LoginPresenter>)presenter fromView:(UIViewController *)viewController;
-(void)dismissViewController:(UIViewController *)viewController;

@end


@interface ApplicationLogic : NSObject

@end

