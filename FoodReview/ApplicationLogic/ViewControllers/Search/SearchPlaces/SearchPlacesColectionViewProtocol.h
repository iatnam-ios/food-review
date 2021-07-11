//
//  SearchPlacesColectionViewProtocol.h
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import <Foundation/Foundation.h>

@class SearchPlacesPresenter;

@protocol SearchPlacesCollectionViewProtocol <NSObject>

@property (nonatomic, strong) SearchPlacesPresenter *presenter;

-(void)showProgressView;
-(void)hideProgressView;
-(void)updateCollectionItems:(NSArray*)array;

@end
