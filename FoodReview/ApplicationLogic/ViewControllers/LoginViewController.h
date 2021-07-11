//
//  LoginViewController.h
//  FoodReview
//
//  Created by MTT on 05/06/2021.
//

#import <UIKit/UIKit.h>
#import "ApplicationLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController<LoginPresenterOutput>

@property (nonatomic, strong) id<LoginPresenter> presenter;

@end

NS_ASSUME_NONNULL_END
