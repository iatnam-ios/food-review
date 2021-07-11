//
//  PlaceListInteractorImplementation.h
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import <Foundation/Foundation.h>
#import "BusinessLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaceListInteractorImp : NSObject<PlaceListInteractor>

-(instancetype)init __unavailable;
-(instancetype)initWithDataStore:(id<AppDataStore>)dataStore NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
