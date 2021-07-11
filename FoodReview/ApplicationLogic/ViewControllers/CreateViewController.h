//
//  CreateViewController.h
//  FoodReview
//
//  Created by MTT on 18/05/2021.
//

#import <UIKit/UIKit.h>
#import "ApplicationLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateViewController : UIViewController<CreateReviewPresenterOutput>

@property (nonatomic, strong) id<CreateReviewPresenter> presenter;

@end

NS_ASSUME_NONNULL_END
