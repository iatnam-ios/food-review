//
//  CreateReviewInteractorImp.h
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import <Foundation/Foundation.h>
#import "BusinessLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateReviewInteractorImp : NSObject<CreateReviewInteractor>

-(instancetype)init __unavailable;
-(instancetype)initWithDataStore:(id<AppDataStore>)dataStore NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
