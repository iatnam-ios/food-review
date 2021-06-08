//
//  BaseCollectionReusableView.h
//  FoodReview
//
//  Created by MTT on 21/05/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BaseCollectionReusableView;

@protocol BaseCollectionReusableViewDelegate <NSObject>
@optional

- (void)didPressSeeAll:(BaseCollectionReusableView *)sender;
- (void)didPressPlay:(BaseCollectionReusableView *)sender;
- (void)didPressShuffle:(BaseCollectionReusableView *)sender;
- (void)didPressAdd:(BaseCollectionReusableView *)sender;
- (void)didPressSort:(BaseCollectionReusableView *)sender;
- (void)didPressAction:(BaseCollectionReusableView *)sender;

@end

@interface BaseCollectionReusableView : UICollectionReusableView

@property (nonatomic, weak) id <BaseCollectionReusableViewDelegate> delegate;
@property (nonatomic) UIView *backingView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIButton *seeAllButton;
@property (nonatomic) UIButton *addButton;
@property (nonatomic) UIButton *sortButton;

+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
