//
//  GenericTableViewSource.h
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import <Foundation/Foundation.h>

@protocol GenericTableViewSourceProtocol

@property (nonatomic, strong, readonly) NSArray *source;

@end

@interface GenericTableViewSource : NSObject <GenericTableViewSourceProtocol,UITableViewDataSource>

-(instancetype)initWithSource:(NSArray*)source;
-(void)setDataSource:(NSArray*)source;
-(void)appendItems:(NSArray*)items;


@end
