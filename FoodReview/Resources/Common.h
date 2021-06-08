//
//  Common.h
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Common : NSObject

+ (UIImage *)imageFromColor:(UIColor *)color;
+ (void)alertWithRootView:(UIView *)rootView message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
