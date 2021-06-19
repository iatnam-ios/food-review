//
//  RealtimeDatabaseGateway.m
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import "RealtimeDatabaseGateway.h"

@implementation RealtimeDatabaseGateway

- (void)getPlacesMatchSearchString:(NSString *)searchText withBlock:(DataGatewayResponseBlock)block {
    FIRDatabase *database = [FIRDatabase databaseWithURL:@"https://food-review-94b9e-default-rtdb.asia-southeast1.firebasedatabase.app"];
    FIRDatabaseReference *restaurantsRef = [database referenceWithPath:@"restaurants"];
    FIRDatabaseQuery *placeQuery = [[[restaurantsRef queryOrderedByChild:@"Name"] queryStartingAtValue:searchText] queryLimitedToFirst:100];
    
    [placeQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%lu", (unsigned long)snapshot.childrenCount);
        NSMutableArray *results = [NSMutableArray new];
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *dict = child.value;
            [results addObject:dict];
        }
        
        block(results, nil);
    }];
}

- (void)getPlacesFromDistrictId:(NSNumber *)districtId withBlock:(DataGatewayResponseBlock)block {
    FIRDatabase *database = [FIRDatabase databaseWithURL:@"https://food-review-94b9e-default-rtdb.asia-southeast1.firebasedatabase.app"];
    FIRDatabaseReference *restaurantsRef = [database referenceWithPath:@"restaurants"];
    FIRDatabaseQuery *placeQuery = [[[restaurantsRef queryOrderedByChild:@"DistrictId"] queryEqualToValue:districtId] queryLimitedToFirst:20];
    
    [placeQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%lu", (unsigned long)snapshot.childrenCount);
        NSMutableArray *results = [NSMutableArray new];
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *dict = child.value;
            [results addObject:dict];
        }
        
        block(results, nil);
    }];
}

@end
