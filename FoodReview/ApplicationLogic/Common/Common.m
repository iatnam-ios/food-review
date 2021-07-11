//
//  Common.m
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#import "Common.h"
#import <UIView+Toast.h>

@implementation Common

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)alertWithRootView:(UIView *)rootView message:(NSString *)message {
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageFont = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    style.messageColor = UIColor.whiteColor;
    style.messageAlignment = NSTextAlignmentCenter;
    style.backgroundColor = UIColor.redPinkColor;
    [rootView makeToast:message duration:3.0 position:CSToastPositionTop style:style];
}

+ (NSString *)getDistanceFromLocation:(CLLocation *)firstLocation toLocation:(CLLocation *)secondLocation {
    CLLocationDistance distance = [firstLocation distanceFromLocation:secondLocation];
    if (distance > 999) {
        NSString *distanceString = [NSString stringWithFormat:@"%.1fkm", (distance / 1000.0)];
        return distanceString;
    } else {
        NSString *distanceString = [NSString stringWithFormat:@"%dm", (int)distance];
        return distanceString;
    }
}

+ (NSString *)suffixNumber:(NSNumber *)number {
    if (!number) {
        return @"";
    }

    long long num = [number longLongValue];

    int s = ((num < 0) ? -1 : (num > 0) ? 1 : 0);
    NSString *sign = s == -1 ? @"-" : @"";

    num = llabs(num);

    if (num < 1000) {
        return [NSString stringWithFormat:@"%@%lld", sign, num];
    }

    int exp = (int)(log10l(num) / 3.f); //log10l(1000));

    NSArray *units = @[@"K",@"M",@"G",@"T",@"P",@"E"];

    return [NSString stringWithFormat:@"%@%.1f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp - 1)]];
}

@end
