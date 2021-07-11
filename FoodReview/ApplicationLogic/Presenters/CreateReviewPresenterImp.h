//
//  CreateReviewPresenterImp.h
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import <Foundation/Foundation.h>
#import "ApplicationLogic.h"
#import "BusinessLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateReviewPresenterImp : NSObject<CreateReviewPresenter, CreateReviewInteractorOutput>

-(instancetype)initWithWireframe:(id<BrowserWireframe>)wireframe interactor:(id<CreateReviewInteractor>)interactor;

@end

NS_ASSUME_NONNULL_END
