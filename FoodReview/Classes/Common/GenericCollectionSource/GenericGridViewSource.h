//
//  GenericGridViewSource.h
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import <Foundation/Foundation.h>

@protocol GenericGridViewSourceProtocol

@property (nonatomic, strong, readonly) NSArray *source;

@end

@interface GenericGridViewSource : NSObject <GenericGridViewSourceProtocol,UICollectionViewDataSource>

-(instancetype)initWithSource:(NSArray*)source;
-(void)setDataSource:(NSArray*)source;
-(void)appendItems:(NSArray*)items;


@end
