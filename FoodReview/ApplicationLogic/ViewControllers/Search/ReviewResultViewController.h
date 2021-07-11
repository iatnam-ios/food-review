//
//  ReviewResultViewController.h
//  FoodReview
//
//  Created by MTT on 11/07/2021.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReviewResultViewController : UIViewController<JXPagerViewListViewDelegate>

@property (nonatomic) NSString *searchText;
-(void)searchResult;

@end

NS_ASSUME_NONNULL_END
