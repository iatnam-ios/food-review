//
//  UIView+Reusable.m
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import "UIView+Reusable.h"

@implementation UIView (Reusable)

+(NSString*)defaultReuseIdentifier
{
    return NSStringFromClass([self class]);
}

+(NSString*)nibName
{
    return NSStringFromClass([self class]);
}

@end
