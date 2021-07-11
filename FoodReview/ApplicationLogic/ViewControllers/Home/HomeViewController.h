//
//  HomeViewController.h
//  FoodReview
//
//  Created by MTT on 18/05/2021.
//

#import <UIKit/UIKit.h>
#import "ApplicationLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController<HomePresenterOutput>

@property (nonatomic, strong) id<HomePresenter> presenter;

@end

NS_ASSUME_NONNULL_END
