//
//  AppDataAdapter.h
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import <Foundation/Foundation.h>
#import "BusinessLogic.h"
#import "ApplicationLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDataAdapter : NSObject<AppDataStore>

-(instancetype)initWithDataSource:(id<AppDataProvider>)dataSource;

@end

NS_ASSUME_NONNULL_END
