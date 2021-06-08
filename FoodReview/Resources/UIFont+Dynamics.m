//
//  UIFont+Dynamics.m
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#import "UIFont+Dynamics.h"

@implementation UIFont (Dynamics)

+ (UIFont *)captionBold {
    return [UIFont systemFontOfSize:18.0 weight:UIFontWeightBold];
}

+ (UIFont *)titleBold {
    return [UIFont systemFontOfSize:22.0 weight:UIFontWeightBold];
}

+ (UIFont *)titleRegular {
    return [UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular];
}

+ (UIFont *)titleLight {
    return [UIFont systemFontOfSize:19.0 weight:UIFontWeightLight];
}

+ (UIFont *)subtitleLight {
    return [UIFont systemFontOfSize:17.0 weight:UIFontWeightLight];
}

@end
