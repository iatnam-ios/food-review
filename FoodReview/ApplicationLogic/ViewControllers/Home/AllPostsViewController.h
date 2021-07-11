//
//  AllPostsViewController.h
//  FoodReview
//
//  Created by MTT on 22/05/2021.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "Review.h"

NS_ASSUME_NONNULL_BEGIN

@interface AllPostsViewController : UIViewController<JXPagerViewListViewDelegate>

@property (nonatomic) PostType type;
@property (nonatomic) NSMutableArray<Review *> *reviews;
@property (nonatomic) NSString *userId;

@end

NS_ASSUME_NONNULL_END
