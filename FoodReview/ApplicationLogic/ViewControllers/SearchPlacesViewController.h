//
//  SearchPlacesViewController.h
//  FoodReview
//
//  Created by MTT on 08/06/2021.
//

#import <UIKit/UIKit.h>
#import "SearchPlacesColectionViewProtocol.h"
#import "Place.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchPlacesViewController : UIViewController<SearchPlacesCollectionViewProtocol>

@property (nonatomic) void (^didSelectedPlace)(Place *place);

@end

NS_ASSUME_NONNULL_END
