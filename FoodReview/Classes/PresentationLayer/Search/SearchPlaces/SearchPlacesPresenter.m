//
//  SearchPlacesPresenter.m
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import "SearchPlacesPresenter.h"

@interface SearchPlacesPresenter()

@end

@implementation SearchPlacesPresenter

-(void)viewDidLoad {
    [self.view showProgressView];
    
    __weak typeof(self) weakSelf = self;
    [self.placeListInteractor getPlacesFromDistrictId:[NSNumber numberWithInteger:24] withBlock:^(NSArray *places, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if(strongSelf)
        {
            if(error)
            {
                [strongSelf showError:error];
            }
            else
            {
                [strongSelf displayAreas:places];
            }
        }
    }];
}

-(void)showError:(NSError*)error
{
    [self.view hideProgressView];
    //[self.router showAlertWithTitle:@"Error" message:error.localizedDescription];
}

-(void)displayAreas:(NSArray<Place*> *)areas
{
    NSArray *array = [self prepareCollectionArrayFromArray:areas];
    [self.view updateCollectionItems:array];
    [self.view hideProgressView];
}

#pragma mark - SearchPlacesPresenterProtocol

- (NSArray *)prepareCollectionArrayFromArray:(NSArray *)areas {
    return areas;
}

- (void)selectedItem:(Place *)item {
    
}

@end
