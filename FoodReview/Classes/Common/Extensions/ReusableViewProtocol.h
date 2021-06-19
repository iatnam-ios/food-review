//
//  ReusableViewProtocol.h
//  FoodReview
//
//  Created by MTT on 17/06/2021.
//

#import <Foundation/Foundation.h>

@protocol ReusableViewProtocol <NSObject>

+(NSString*)defaultReuseIdentifier;

@end

@protocol NibLoadableViewProtocol <NSObject>

+(NSString*)nibName;

@end

@protocol UIViewCellRegisterProtocol <NSObject>

-(void)registerCell:(Class<ReusableViewProtocol>) type;
-(void)registerCellNib:(Class<NibLoadableViewProtocol, ReusableViewProtocol>) type;

@end
