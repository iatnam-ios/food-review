//
//  BusinessLogic.m
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import "BusinessLogic.h"
#import "CreateReviewInteractorImp.h"
#import "HomeInteractorImp.h"

@implementation BusinessLogic

+ (id<CreateReviewInteractor>)makeCreateReviewInteractor:(id<AppDataStore>)dataStore {
    CreateReviewInteractorImp *interactor = [[CreateReviewInteractorImp alloc] initWithDataStore:dataStore];
    return interactor;
}

+ (id<HomeInteractor>)makeHomeInteractor:(id<AppDataStore>)dataStore {
    HomeInteractorImp *interactor = [[HomeInteractorImp alloc] initWithDataStore:dataStore];
    return interactor;
}

@end
