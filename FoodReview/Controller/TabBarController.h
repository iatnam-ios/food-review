//
//  TabBarController.h
//  FoodReview
//
//  Created by MTT on 18/05/2021.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "VideoViewController.h"
#import "CreateViewController.h"
#import "NotificationViewController.h"
#import "UserViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabBarController : UITabBarController

@property (nonatomic) UIView *statusBar;
@property (nonatomic) HomeViewController *homeViewController;
@property (nonatomic) VideoViewController *videoViewController;
@property (nonatomic) CreateViewController *createViewController;
@property (nonatomic) NotificationViewController *notificationViewController;
@property (nonatomic) UserViewController *userViewController;

+ (instancetype)sharedInstance;

- (void)setupViews;
- (nullable UINavigationController *)currentNavigationController;
- (void)switchToSearchWithCompletion: (void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
