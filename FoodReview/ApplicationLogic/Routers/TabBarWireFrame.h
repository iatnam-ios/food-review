//
//  TabBarWireFrame.h
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import <Foundation/Foundation.h>
#import "ApplicationLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabBarWireFrame : NSObject<BrowserWireframe>

-(instancetype)initWithDataProvider:(id<AppDataProvider>)dataProvider;
-(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END
