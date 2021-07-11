//
//  SearchPlacesPresenter.h
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import <Foundation/Foundation.h>
#import "BusinessLogic.h"
#import "SearchPlacesColectionViewProtocol.h"

@class Place;
@protocol SearchPlacesPresenterProtocol

-(NSArray*) prepareCollectionArrayFromArray:(NSArray *)areas;
-(void)selectedItem:(Place *)item;

@end

@interface SearchPlacesPresenter : NSObject <SearchPlacesPresenterProtocol>

@property (nonatomic, weak) id<SearchPlacesCollectionViewProtocol> view;
//@property (nonatomic, strong) EmplesItemRouter *router;

@property (nonatomic, strong) id<PlaceListInteractor> placeListInteractor;

-(void)viewDidLoad;

@end
