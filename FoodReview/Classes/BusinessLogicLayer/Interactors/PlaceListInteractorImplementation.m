//
//  PlaceListInteractorImplementation.m
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import "PlaceListInteractorImplementation.h"
#import "Place.h"

@interface PlaceListInteractorImplementation()

@property (nonatomic, strong) id<DataGatewayProtocol> gateway;

@end

@implementation PlaceListInteractorImplementation

- (instancetype)initWithGateway:(id<DataGatewayProtocol>)gateway {
    self = [super init];
    if(self)
    {
        self.gateway = gateway;
    }
    return self;
}

- (void)getPlacesMatchSearchString:(NSString *)searchText withBlock:(GetPlacesResponseBlock)completionHandler {
    [self.gateway getPlacesMatchSearchString:searchText withBlock:^(id response, NSError *error) {
        if(!error && [response isKindOfClass:[NSArray class]])
        {
            NSArray *array = [self processArray:(NSArray*)response];
            completionHandler(array, nil);
        }
        else
        {
            completionHandler(nil, error);
        }
    }];
}

- (void)getPlacesFromDistrictId:(NSNumber *)districtId withBlock:(GetPlacesResponseBlock)completionHandler {
    [self.gateway getPlacesFromDistrictId:districtId withBlock:^(id response, NSError *error) {
        if(!error && [response isKindOfClass:[NSArray class]])
        {
            NSArray *array = [self processArray:(NSArray*)response];
            completionHandler(array, nil);
        }
        else
        {
            completionHandler(nil, error);
        }
    }];
}

-(NSArray*)processArray:(NSArray<Place *> *)array
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *item in array)
    {
        Place *place = [[Place alloc] initWithDictionary:item];
        [resultArray addObject:place];
    }
    return resultArray;
}

@end
