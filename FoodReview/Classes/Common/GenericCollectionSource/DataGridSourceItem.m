//
//  DataGridSourceItem.m
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import "DataGridSourceItem.h"

@implementation DataGridSourceItem

- (instancetype)initWithCellModel:(id<ViewCellModelProtocol>)cellModel
{
    self = [super init];
    if (self)
    {
        self.cellModel = cellModel;
        self.itemSize = CGSizeMake(50, 50);
    }
    
    return self;
}
- (id)value
{
    return [self.cellModel getModelValue];
}

@end
