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

@end
