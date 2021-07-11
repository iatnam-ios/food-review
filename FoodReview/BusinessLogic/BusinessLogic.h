//
//  BusinessLogic.h
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import <Foundation/Foundation.h>
#import "DomainEntities.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PlaceListInteractor;
@protocol PlaceListInteractorOutput;
@protocol CreateReviewInteractor;
@protocol CreateReviewInteractorOutput;
@protocol LandingInteractor;
@protocol LandingInteractorOutput;
@protocol LoginInteractor;
@protocol LoginInteractorOutput;
@protocol HomeInteractor;
@protocol HomeInteractorOutput;

@protocol AppDataStore;


#pragma mark - PlaceListInteractor

@protocol PlaceListInteractor <NSObject>

@property (nonatomic, weak) id<PlaceListInteractorOutput> output;

-(void)getPlacesMatchSearchString:(NSString *)searchText;

-(void)getPlacesFromDistrictId:(NSInteger)districtId;

@end

#pragma mark - PlaceListInteractorOutput

@protocol PlaceListInteractorOutput <NSObject>

-(void)placeList:(id<PlaceListInteractor>)interactor didReceivePlaces:(NSArray<Place *> *)results;

-(void)placeList:(id<PlaceListInteractor>)interactor didReceiveError:(NSError *)error;

@optional
-(void)placeList:(id<PlaceListInteractor>)interactor didReceiveSuggestionPlaces:(NSArray<Place *> *)results;

@end

#pragma mark - CreateReviewInteractor

@protocol CreateReviewInteractor <NSObject>

@property (nonatomic, weak) id<CreateReviewInteractorOutput> output;

-(void)getCurrentUser;
-(id<LandingInteractor>)makeLandingInteractor;

@end

#pragma mark - CreateReviewInteractorOutput

@protocol CreateReviewInteractorOutput <NSObject>

-(void)didReceiveCurrentUser:(nullable User *)user;

@end

#pragma mark - LandingInteractor

@protocol LandingInteractor <NSObject>

@property (nonatomic, weak) id<LandingInteractorOutput> output;

-(id<LoginInteractor>)makeLoginInteractor;

@end

#pragma mark - LandingInteractorOutput

@protocol LandingInteractorOutput <NSObject>


@end

#pragma mark - LoginInteractor

@protocol LoginInteractor <NSObject>

@property (nonatomic, weak) id<LoginInteractorOutput> output;

-(void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;

@end

#pragma mark - LoginInteractorOutput

@protocol LoginInteractorOutput <NSObject>

-(void)didLoginWith:(User *)user;
-(void)didLoginError:(NSString *)error;

@end

#pragma mark - HomeInteractor

@protocol HomeInteractor <NSObject>

@property (nonatomic, weak) id<HomeInteractorOutput> output;

-(void)getEditorsChoice;
-(void)getTrending;

@end

#pragma mark - HomeInteractorOutput

@protocol HomeInteractorOutput <NSObject>

-(void)didReceiveEditorsChoice:(NSArray<Category *> *)items;
-(void)didReceiveTrending:(NSArray<Category *> *)items;

@end

#pragma mark - AppDataStore

@protocol AppDataStore <NSObject>

-(void)getCurrentUserWithBlock:(UserResponseBlock)block;
-(void)loginWithEmail:(NSString *)email password:(NSString *)password andWithBlock:(LoginResponseBlock)block;

-(void)getPlacesMatchSearchString:(NSString *)searchText withBlock:(PlacesResponseBlock)block;

-(void)getPlacesFromDistrictId:(NSInteger)districtId withBlock:(PlacesResponseBlock)block;

-(void)getEditorsChoiceWithBlock:(CategoriesResponseBlock)block;
-(void)getTrendingWithBlock:(CategoriesResponseBlock)block;

@end


@interface BusinessLogic : NSObject

+(id<CreateReviewInteractor>)makeCreateReviewInteractor:(id<AppDataStore>)dataStore;
+(id<HomeInteractor>)makeHomeInteractor:(id<AppDataStore>)dataStore;

@end

NS_ASSUME_NONNULL_END
