//
//  UICollectionView+Reusable.m
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import "UICollectionView+Reusable.h"

@implementation UICollectionView (Reusable)

-(void)registerCell:(Class<ReusableViewProtocol>) type
{
    [self registerClass:type forCellWithReuseIdentifier:[type defaultReuseIdentifier]];
}

-(void)registerCellNib:(Class<NibLoadableViewProtocol,ReusableViewProtocol>) type
{
    NSBundle *bundle = [NSBundle mainBundle];
    UINib *nib = [UINib nibWithNibName:[type nibName]
                                bundle:bundle];
    [self registerNib:nib forCellWithReuseIdentifier:[type defaultReuseIdentifier]];
}

@end
