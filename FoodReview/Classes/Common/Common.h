//
//  Common.h
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Common : NSObject

+ (UIImage *)imageFromColor:(UIColor *)color;
+ (void)alertWithRootView:(UIView *)rootView message:(NSString *)message;
+ (NSString *)getDistanceFromLocation:(CLLocation *)firstLocation toLocation:(CLLocation *)secondLocation;

@end

NS_ASSUME_NONNULL_END
