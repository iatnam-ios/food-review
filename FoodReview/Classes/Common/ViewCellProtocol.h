//
//  ViewCellProtocol.h
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import <Foundation/Foundation.h>
#import "ViewCellModelProtocol.h"

@protocol ViewCellModelProtocol;

@protocol ViewCellProtocol <NSObject>

- (void)configureWithModel:(id<ViewCellModelProtocol>)model;

@end
