//
//  DecoratorModelProtocol.h
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import <Foundation/Foundation.h>

@protocol DecoratorModelProtocol <NSObject>

@property (nonatomic, strong, readonly) NSArray *dataSource;

@end
