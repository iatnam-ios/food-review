//
//  ViewControllerRouter.h
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewControllerRouter : NSObject

+ (instancetype)shared;

-(UIViewController *)createSearchPlacesVC;

@end

NS_ASSUME_NONNULL_END
