//
//  ExternalInterfaces.m
//  FoodReview
//
//  Created by MTT on 19/06/2021.
//

#import "ExternalInterfaces.h"
#import "FirebaseDatabaseClient.h"

@implementation ExternalInterfaces

+ (id<AppDataProvider>)makeAppDatabaseClient {
    FirebaseDatabaseClient *client = [[FirebaseDatabaseClient alloc] init];
    return client;
}

@end
