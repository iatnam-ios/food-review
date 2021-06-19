//
//  PlaceListInteractor.h
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import <Foundation/Foundation.h>

@protocol DataGatewayProtocol;
typedef void(^GetPlacesResponseBlock)(NSArray* places, NSError *error);

@protocol PlaceListInteractor <NSObject>

-(instancetype)initWithGateway:(id<DataGatewayProtocol>)gateway;

-(void)getPlacesMatchSearchString:(NSString *)searchText withBlock:(GetPlacesResponseBlock)completionHandler;

-(void)getPlacesFromDistrictId:(NSNumber *)districtId withBlock:(GetPlacesResponseBlock)completionHandler;

@end
