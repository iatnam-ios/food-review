//
//  PhotoCollectionViewCell.h
//  FoodReview
//
//  Created by MTT on 29/06/2021.
//

#import "BaseCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoCollectionViewCell : BaseCollectionCell

+ (NSString *)identifier;

-(void)configCellWithImageUrl:(NSURL *)imageUrl;
-(void)configCellWithImage:(UIImage *)image;
-(void)configCellAddImage;

@end

NS_ASSUME_NONNULL_END
