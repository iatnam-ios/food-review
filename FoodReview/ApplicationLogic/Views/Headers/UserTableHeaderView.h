//
//  UserTableHeaderView.h
//  FoodReview
//
//  Created by MTT on 01/07/2021.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@class UserTableHeaderView;

@protocol UserTableHeaderViewDelegate <NSObject>

- (void)didPressFollowButton:(UIButton *)sender;
- (void)didPressDetailButton:(UIButton *)sender;

@end

@interface UserTableHeaderView : UIView

@property (nonatomic, weak) id <UserTableHeaderViewDelegate> delegate;
@property (nonatomic) UIButton *followButton;

-(void)setupForCurrentUser:(User *)user;
-(void)setup:(User *)user;
-(void)setReviewLabel:(NSInteger)value;
-(void)setFollowerLabel:(NSInteger)value;
-(void)setFollowedLabel:(NSInteger)value;

@end

NS_ASSUME_NONNULL_END
