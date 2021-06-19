//
//  DataGatewayProtocol.h
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import <Foundation/Foundation.h>

typedef void(^DataGatewayResponseBlock)(id response, NSError *error);

@protocol DataGatewayProtocol <NSObject>

@optional

-(void)getPlacesMatchSearchString:(NSString *)searchText withBlock:(DataGatewayResponseBlock)block;

-(void)getPlacesFromDistrictId:(NSNumber *)districtId withBlock:(DataGatewayResponseBlock)block;

@end
