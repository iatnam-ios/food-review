//
//  ContentCollectionReusableView.h
//  FoodReview
//
//  Created by MTT on 09/07/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentCollectionReusableView : UICollectionReusableView

+ (NSString *)identifier;
-(void)configViewWithTitle:(NSString *)title content:(NSString *)content hashtag:(NSString *)hashtag rating:(float)rate andTotalViews:(NSInteger)value;

@end

NS_ASSUME_NONNULL_END
