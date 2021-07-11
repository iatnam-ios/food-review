//
//  CommentCollectionViewCell.h
//  FoodReview
//
//  Created by MTT on 09/07/2021.
//

#import "BaseCollectionCell.h"
#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentCollectionViewCell : BaseCollectionCell

+ (NSString *)identifier;
-(void)configCellWithComment:(Comment *)comment;

@end

NS_ASSUME_NONNULL_END
