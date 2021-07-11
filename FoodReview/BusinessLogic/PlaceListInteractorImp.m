//
//  PlaceListInteractorImplementation.m
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import "PlaceListInteractorImp.h"
#import "Place.h"

@interface PlaceListInteractorImp()

@property (nonatomic, strong) id<AppDataStore> dataStore;

@end

@implementation PlaceListInteractorImp

@synthesize output;

- (instancetype)initWithDataStore:(id<AppDataStore>)dataStore {
    self = [super init];
    if(self)
    {
        self.dataStore = dataStore;
    }
    return self;
}

- (void)getPlacesFromDistrictId:(NSInteger)districtId {
    if (self.output) {
        [self.dataStore getPlacesFromDistrictId:districtId withBlock:^(NSArray<Place *> *places, NSError *error) {
            if (error) {
                [self.output placeList:self didReceiveError:error];
            } else {
                [self.output placeList:self didReceiveSuggestionPlaces:places];
            }
        }];
    }
}

- (void)getPlacesMatchSearchString:(NSString *)searchText {
    if (self.output) {
        [self.dataStore getPlacesMatchSearchString:searchText withBlock:^(NSArray<Place *> *places, NSError *error) {
            if (error) {
                [self.output placeList:self didReceiveError:error];
            } else {
                [self.output placeList:self didReceivePlaces:places];
            }
        }];
    }
}

@end
