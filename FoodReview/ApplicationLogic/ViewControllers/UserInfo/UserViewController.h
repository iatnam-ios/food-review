//
//  UserViewController.h
//  FoodReview
//
//  Created by MTT on 18/05/2021.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserViewController : UIViewController

@property (nonatomic, nullable) NSString *userId;
@property (nonatomic) BOOL isCurrentUser;

@end

NS_ASSUME_NONNULL_END
