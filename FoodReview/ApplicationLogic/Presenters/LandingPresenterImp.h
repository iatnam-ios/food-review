//
//  LandingPresenterImp.h
//  FoodReview
//
//  Created by MTT on 20/06/2021.
//

#import <Foundation/Foundation.h>
#import "BusinessLogic.h"
#import "ApplicationLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface LandingPresenterImp : NSObject<LandingPresenter, LandingInteractorOutput>

-(instancetype)initWithWireframe:(id<BrowserWireframe>)wireframe interactor:(id<LandingInteractor>)interactor;

@end

NS_ASSUME_NONNULL_END
