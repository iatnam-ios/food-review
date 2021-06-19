//
//  DataGridSourceItem.h
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import <Foundation/Foundation.h>
#import "ViewCellModelProtocol.h"

@interface DataGridSourceItem : NSObject

@property (strong, nonatomic) id<ViewCellModelProtocol> cellModel;
@property (strong, nonatomic, readonly) id value;
@property (assign, nonatomic) CGSize itemSize;
@property (nonatomic, copy) void (^selectAction)(id<ViewCellModelProtocol> cellModel);

- (instancetype)initWithCellModel:(id<ViewCellModelProtocol>)cellModel;

@end
