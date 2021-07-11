//
//  ExternalInterfaces.h
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import <Foundation/Foundation.h>
#import "ApplicationLogic.h"

@interface ExternalInterfaces : NSObject

+(id<AppDataProvider>)makeAppDatabaseClient;

@end

