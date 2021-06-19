//
//  PlaceListInteractorImplementation.h
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import <Foundation/Foundation.h>
#import "PlaceListInteractor.h"
#import "DataGatewayProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaceListInteractorImplementation : NSObject<PlaceListInteractor>

-(instancetype)init __unavailable;
-(instancetype)initWithGateway:(id<DataGatewayProtocol>)gateway NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
