//
//  DataSourceItem.m
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import "DataSourceItem.h"

@implementation DataSourceItem

- (instancetype)initWithCellModel:(id<ViewCellModelProtocol>)cellModel
{
    self = [super init];
    if (self)
    {
        self.cellModel = cellModel;
        self.rowHeight = 60;
    }
    
    return self;
}

- (id)value
{
    return [self.cellModel getModelValue];
}


@end
