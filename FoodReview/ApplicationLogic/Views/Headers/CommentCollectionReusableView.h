//
//  CommentCollectionReusableView.h
//  FoodReview
//
//  Created by MTT on 09/07/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CommentCollectionReusableView;

@protocol CommentCollectionReusableDelegate <NSObject>

- (void)didPressLikeButton:(CommentCollectionReusableView *)sender;
- (void)didPressDislikeButton:(CommentCollectionReusableView *)sender;
- (void)didPressCommentButton:(UIButton *)sender withComment:(NSString *)content;

@end

@interface CommentCollectionReusableView : UICollectionReusableView

@property (nonatomic, weak) id <CommentCollectionReusableDelegate> delegate;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *dislikeButton;

+ (NSString *)identifier;
-(void)configViewWithLikes:(NSInteger)likes dislikes:(NSInteger)dislikes andComments:(NSInteger)comments;

@end

NS_ASSUME_NONNULL_END
