//
//  GenericTableViewManager.h
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol UITableSourceManager <NSObject>

- (instancetype)initWithSource:(NSArray*)source;
- (void)updateDataSource:(NSArray*)source;
- (void)appendItems:(NSArray*)items;
- (id<UITableViewDataSource>)dataSourceForTableView:(UITableView *)tableView;
- (id<UITableViewDelegate>)delegateForTableView:(UITableView *)tableView;

@end

@interface GenericTableViewManager : NSObject<UITableSourceManager>

@end
