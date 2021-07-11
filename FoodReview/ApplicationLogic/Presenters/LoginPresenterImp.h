//
//  LoginPresenterImp.h
//  FoodReview
//
//  Created by MTT on 20/06/2021.
//

#import <Foundation/Foundation.h>
#import "BusinessLogic.h"
#import "ApplicationLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginPresenterImp : NSObject<LoginPresenter, LoginInteractorOutput>

-(instancetype)initWithWireframe:(id<BrowserWireframe>)wireframe interactor:(id<LoginInteractor>)interactor;

@end

NS_ASSUME_NONNULL_END
