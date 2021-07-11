//
//  LandingViewController.h
//  FoodReview
//
//  Created by MTT on 05/06/2021.
//

#import <UIKit/UIKit.h>
#import "ApplicationLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface LandingViewController : UIViewController<LandingPresenterOutput>

@property (nonatomic, strong) id<LandingPresenter> presenter;

@end

NS_ASSUME_NONNULL_END
