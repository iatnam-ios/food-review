//
//  UIColor+MSCAdditions.m
//  FoodReview
//
//  Created by MTT on 18/05/2021.
//

#import "UIColor+MSCAdditions.h"

@implementation UIColor (MSCAdditions)

+ (UIColor *)colorWithHex:(NSInteger)hex {
    return [UIColor colorWithRed:((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0 green:((CGFloat)((hex & 0xFF00) >> 8)) / 255.0 blue:(CGFloat)(hex & 0xFF) / 255.0 alpha: 1.0];
}

+ (UIColor *)redPinkColor {
    return [UIColor colorWithHex:0xfd2959];
}

+ (UIColor *)buttonColor {
    return [UIColor colorWithHex:0xff5a66];
}

+ (UIColor *)steelColor {
    return [UIColor colorWithRed:128.0f / 255.0f green:130.0f / 255.0f blue:138.0f / 255.0f alpha:1.0f];
}

+ (UIColor *)smokyGrayColor {
    return [UIColor colorWithRed:134.0f / 255.0f green:134.0f / 255.0f blue:134.0f / 255.0f alpha:1.0f];
}

+ (UIColor *)blueberryColor {
    return [UIColor colorWithRed:72.0f / 255.0f green:68.0f / 255.0f blue:145.0f / 255.0f alpha:1.0f];
}

+ (UIColor *)brownGreyColor {
    return [UIColor colorWithRed:155.0f / 255.0f green:155.0f / 255.0f blue:155.0f / 255.0f alpha:1.0f];
}

+ (UIColor *)highlightedColor {
    return [[UIColor alloc] initWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [[UIColor alloc] initWithWhite:0.5 alpha:0.5];
        } else {
           return [[UIColor alloc] initWithWhite:0.9 alpha:0.9];
        }
    }];
}

+ (UIColor *)selectedColor {
    return [[UIColor alloc] initWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [[UIColor alloc] initWithWhite:0.5 alpha:0.5];
        } else {
           return [[UIColor alloc] initWithWhite:0.9 alpha:0.9];
        }
    }];
}

@end
