//
//  CustomTextField.m
//  FoodReview
//
//  Created by MTT on 06/06/2021.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    if (self.isSmallSpace) {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 5, 0, 5));
    }
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 15, 0, 35));
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    if (self.isSmallSpace) {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 5, 0, 5));
    }
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 15, 0, 35));
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (self.isSmallSpace) {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 5, 0, 5));
    }
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 15, 0, 35));
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.size.width - 34, (bounds.size.height - 24) / 2.0, 24, 24);
}

@end
