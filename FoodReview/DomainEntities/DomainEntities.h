//
//  DomainEntities.h
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import <Foundation/Foundation.h>
#import "Place.h"
#import "User.h"
#import "Category.h"

typedef void(^PlacesResponseBlock)(NSArray<Place *> * _Nonnull places, NSError * _Nullable error);
typedef void(^CategoriesResponseBlock)(NSArray<Category *> * _Nonnull category, NSError * _Nullable error);
typedef void(^UserResponseBlock)(User * _Nullable user);
typedef void(^LoginResponseBlock)(User * _Nullable user, NSString * _Nullable error);

@interface DomainEntities : NSObject

@end

