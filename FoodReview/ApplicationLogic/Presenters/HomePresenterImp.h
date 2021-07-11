//
//  HomePresenterImp.h
//  FoodReview
//
//  Created by MTT on 29/06/2021.
//

#import <Foundation/Foundation.h>
#import "BusinessLogic.h"
#import "ApplicationLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePresenterImp : NSObject<HomePresenter, HomeInteractorOutput>

-(instancetype)initWithWireframe:(id<BrowserWireframe>)wireframe interactor:(id<HomeInteractor>)interactor;

@end

NS_ASSUME_NONNULL_END
